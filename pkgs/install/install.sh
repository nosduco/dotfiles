# args
if [[ $# -lt 2 || $# -gt 3 ]]; then
  echo "usage: install <host> <ip> [port]" >&2
  exit 1
fi
host=$1
ip=$2
port=${3:-22}
hw="hosts/$host/hardware-configuration.nix"

# checks
if [[ " $HOSTS " != *" $host "* ]]; then
  echo "unknown host '$host' (installable: $HOSTS)" >&2
  exit 1
fi
if ! root=$(git rev-parse --show-toplevel 2>/dev/null) || [[ ! -f $root/hosts/$host/disko.nix ]]; then
  echo "run this from the nixos-config repo" >&2
  exit 1
fi
cd "$root"
if [[ -n $(git status --porcelain) ]]; then
  echo "working tree is dirty, commit or stash first" >&2
  exit 1
fi
if ! git commit-tree -S -m test 'HEAD^{tree}' >/dev/null 2>&1; then
  echo "git commit signing is not set up in $root" >&2
  exit 1
fi
git fetch --quiet
if [[ $(git rev-parse HEAD) != $(git rev-parse '@{upstream}') ]]; then
  echo "branch is not in sync with $(git rev-parse --abbrev-ref '@{upstream}'), pull or push first" >&2
  exit 1
fi

# age key
age_key=${AGE_KEY:-$HOME/.config/sops/age/dotfiles.txt}
dotfiles_pub=$(sed -n 's/.*&dotfiles \(age1[a-z0-9]*\).*/\1/p' .sops.yaml)
if [[ ! -r $age_key ]] || [[ $(age-keygen -y "$age_key") != "$dotfiles_pub" ]]; then
  echo "$age_key is not the dotfiles age key ($dotfiles_pub)" >&2
  exit 1
fi

# extra files
tmp=$(mktemp -d -p "${XDG_RUNTIME_DIR:?}")
trap 'rm -rf "$tmp"' EXIT
key_file=$(nix eval --raw ".#nixosConfigurations.$host.config.sops.age.keyFile")
(umask 022 && install -d "$tmp/extra$(dirname "$key_file")")
install -m400 "$age_key" "$tmp/extra$key_file"

# ssh
ssh-keygen -q -t ed25519 -N "" -C install -f "$tmp/ssh"
ssh_opts=(-p "$port" -i "$tmp/ssh" -o IdentitiesOnly=yes -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o LogLevel=ERROR)
read -rsp "root password of the installer on $ip: " SSHPASS
echo
export SSHPASS
anywhere=(nixos-anywhere --flake ".#$host" --target-host "root@$ip" -p "$port" -i "$tmp/ssh" --env-password)

# hardware config
"${anywhere[@]}" --phases kexec --generate-hardware-config nixos-generate-config "$hw"
git --no-pager diff --stat -- "$hw"

# confirm
ssh "${ssh_opts[@]}" "root@$ip" lsblk -o NAME,SIZE,TYPE,MODEL,SERIAL
echo "disko will ERASE $(sed -n 's/.*device = "\(.*\)".*/\1/p' "hosts/$host/disko.nix") on $ip"
read -rp "type '$host' to continue: " answer
if [[ $answer != "$host" ]]; then
  echo "aborted, $hw is left modified" >&2
  exit 1
fi

# luks passphrase
read -rsp "disk passphrase: " pass
echo
read -rsp "disk passphrase again: " pass2
echo
if [[ -z $pass || $pass != "$pass2" ]]; then
  echo "passphrases are empty or differ" >&2
  exit 1
fi

# commit
git commit -S -m "feat($host): generate hardware configuration" -- "$hw"
git push

# install
"${anywhere[@]}" --phases disko,install \
  --disk-encryption-keys /tmp/secret.key <(printf %s "$pass") \
  --extra-files "$tmp/extra"

# reboot
if [[ $(nix eval ".#nixosConfigurations.$host.config" --apply 'c: c.boot.lanzaboote.enable or false') == true ]]; then
  echo "rebooting into firmware setup: reset Secure Boot to Setup Mode, then boot the disk"
  ssh "${ssh_opts[@]}" "root@$ip" 'systemctl reboot --firmware-setup || systemctl reboot' || true
else
  echo "rebooting"
  ssh "${ssh_opts[@]}" "root@$ip" 'systemctl reboot' || true
fi
