# Kopia desktop backups

Replaces Vorta. Snapshots to tux over LAN; tux replicates the repo to B2.

```
sources ──► sftp://kopia@tux/tank/data/backups/endpoints/<host>   (02:00, daily, LAN)
                         │
                         └──► b2://tuxcloud-endpoints-backups/<host>/  (03:30, driven by tux-side CronJob)
```

Desktop does LAN-only; tux handles all off-site traffic.

## 0 → fully set up

```fish
# 1. Install packages, symlink units, enable timer. Idempotent.
cd ~/.dotfiles && ./install

# 2. Verify SSH to tux as kopia (add host to kopia-sftp-user ansible role if new)
ssh -p 22 kopia@tux hostname

# 3. Drop creds in. Single file, 600-mode.
install -m 600 /dev/stdin ~/.config/kopia/env <<'EOF'
KOPIA_PASSWORD=<strong random password - save in password manager!>
EOF
```

Done. On the next 02:00 tick the snapshot timer auto-creates the repo, reconciles
policy from `sources.txt` / `ignore-patterns.txt`, snapshots all 15 paths. Tux's
`kopia-endpoints-sync` CronJob picks it up at 03:30 and replicates to B2.

Skip the wait: `systemctl --user start kopia-snapshot.service`.

## Editing sources / ignores

```fish
$EDITOR ~/.dotfiles/kopia/{sources.txt,ignore-patterns.txt}
```

Next daily run reconciles automatically. Force-apply sooner with
`~/.dotfiles/kopia/scripts/apply-policies.sh`.

## Restore

```fish
kopia --config-file=~/.config/kopia/tux-sftp.config snapshot list --all
kopia --config-file=~/.config/kopia/tux-sftp.config restore <id> /tmp/restore
kopia --config-file=~/.config/kopia/tux-sftp.config mount <id> /tmp/kopia-mount
```

If tux is gone entirely: connect to B2 directly with the same password:
```fish
kopia repository connect b2 \
    --bucket=tuxcloud-endpoints-backups --prefix=<host>/ \
    --key-id=<endpoints app key id> --key=<endpoints app key>
```

KopiaUI (`kopia-ui`) auto-discovers the config for browse/restore.

## Retention

10 latest / 30 daily / 12 weekly / 24 monthly / 5 yearly. Set in `apply-policies.sh`.

## Failure notifications

- Desktop side: `systemd OnFailure=kopia-notify@%n.service` fires a local
  `notify-send` desktop notification if the timer unit exits non-zero.
- Tux side (sync-to-B2): `platform/kopia-endpoints-sync/` CronJob posts to
  ntfy `alerts-critical` via the standard `trap ERR` pattern.
