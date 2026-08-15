# tuxcloud mount (`~/cloud`)

`tuxcloud` is the OpenCloud server running on tux, mounted as an ordinary
directory via `rclone mount` (FUSE + WebDAV). Nothing is stored locally beyond a
bounded cache: `~/cloud` is a live view of the server.

```
files.tuxcloud.xyz (10.8.40.4)      OpenCloud 7.x
        │  WebDAV  /remote.php/dav/files/tony/
        ▼
rclone mount  ──►  ~/cloud   (FUSE, vfs-cache-mode full, 10G cap)
                     │
                     ├── yazi        (plain dir; `g t` jumps here)
                     ├── Nautilus    (plain dir; sidebar bookmark "tuxcloud")
                     └── cd ~/cloud
```

The mount point stays `~/cloud` rather than `~/tuxcloud` — short to type, and
there is only ever one cloud mount on these machines. Everything that *names*
the thing (rclone remote, systemd unit, keybind, bookmark) says `tuxcloud`.

## 0 → mounted

```fish
# 1. Configure the rclone remote (one-time, per machine; holds the credential)
rclone config create tuxcloud webdav \
    url=https://files.tuxcloud.xyz/remote.php/dav/files/tony/ \
    vendor=owncloud \
    user=tony \
    pass=<opencloud app password>

# 2. Verify it reaches the server
rclone lsd tuxcloud:

# 3. Install + enable. Idempotent.
cd ~/.dotfiles && ./install
```

Step 3 is a no-op with a printed skip message if step 1 has not been done, so
`./install` stays safe on a machine that has no tuxcloud credential.

## What gets installed

| File | What it does |
|--|--|
| `~/.config/systemd/user/rclone-tuxcloud.service` | Symlink to `systemd/user/rclone-tuxcloud.service`. Mounts `tuxcloud:` at `~/cloud`, `WantedBy=default.target`. |
| `~/cloud` | Mount point. Created by `ExecStartPre`. |
| `~/.cache/rclone` | VFS cache. Capped at 10G, entries evicted after 168h idle. |
| `~/.config/gtk-3.0/bookmarks` | Appends a `tuxcloud` entry for the Nautilus sidebar. |
| `yazi/keymap.toml` | `g t` jumps to `~/cloud`. |

## Why these particular flags

- `--vfs-cache-mode full` — the mount has to behave like a real filesystem, not a
  streaming view. Anything doing random reads or in-place writes (editors,
  sqlite, video players, LibreOffice) breaks under the lighter `writes` mode.
- `--vfs-cache-max-size 10G` — bounded so the cache cannot eat the disk. The
  remote is ~59 GiB, so this is a working set, not a mirror.
- `--dir-cache-time 5m` — directory listings cost ~100 ms round-trip on the LAN.
  Caching for 5m makes browsing feel local; the cost is up to 5m of staleness for
  changes made from another device.
- `--poll-interval 0` — the WebDAV backend reports `ChangeNotify: false`, so
  polling for server-side changes does nothing. Disabled explicitly rather than
  left at the default 1m, which would only add noise.
- `--attr-timeout 5s` — kernel-side attribute cache. Cuts repeated `stat()`
  storms (`ls -l`, yazi previews) down to one round-trip.
- `Type=notify` — rclone signals readiness, so dependent units and the first `ls`
  do not race the mount.
- `Restart=on-failure` + `RestartSec=30s` — recovers from a server or network
  blip. A clean manual unmount does not trigger a restart loop.
- `vendor=owncloud` — OpenCloud is a fork of ownCloud Infinite Scale, and rclone
  also ships an `infinitescale` vendor. Both were tested against this server and
  behave identically on listing. Switch to `infinitescale` if chunked uploads
  ever misbehave.

## Keybind note

`g t` is used because yazi 26.5.6 only defines `g` + `c` / `d` / `f` / `g` / `h` /
`<Space>` by default, so nothing is shadowed. Verify after a yazi upgrade:

```fish
strings (which yazi) | grep -oE '"g", *"[^"]+"' | sort -u
```

## Caveats

**LAN-only DNS.** `files.tuxcloud.xyz` resolves to `10.8.40.4`, which is not
public. Off-LAN the mount stalls and I/O errors. The `firewall` tailscale peer
advertises `10.8.40.0/24`, but `--accept-routes` is off by default, so a roaming
machine (voyager) needs:

```fish
tailscale set --accept-routes
```

plus DNS for the `.xyz` name over the tailnet. Until that is done, treat the
mount as LAN-only.

**Writes are asynchronous.** With `vfs-cache-mode full`, a write lands in the
local cache immediately and uploads shortly after (measured ~6s for a small
file). `~/cloud` reads back the new content instantly; the *server* takes a
moment. Do not power off right after a large write.

**WebDAV is not a local disk.** ~100 ms per uncached directory listing on the
LAN. Fine for documents. Poor for git repositories, huge trees, or video
scrubbing. Keep those on local disk.

**`~/cloud` is deliberately excluded from kopia.** See the header comment in
`kopia/sources.txt`. The server already holds this data and replicates it to B2
itself; snapshotting the mount would duplicate ~59 GiB and back up a network
filesystem.

**Credential storage.** `~/.config/rclone/rclone.conf` is not encrypted. The
password is `rclone obscure`d, which is reversible via `rclone reveal`. Anything
that can read the file has the credential — including the kopia snapshot of
`~/.config`. Use a scoped OpenCloud app password rather than the account
password, or set an rclone config password (`rclone config` → `s`), which then
has to be supplied to the systemd unit at start.

## Verifying state

```fish
systemctl --user status rclone-tuxcloud.service
mount | grep '/home/.*/cloud'                    # fuse.rclone
ls ~/cloud
journalctl --user -u rclone-tuxcloud -n 20 --no-pager
rclone about tuxcloud:                           # server-side usage
du -sh ~/.cache/rclone                           # cache footprint vs 10G cap
```

## Reverting

```fish
systemctl --user disable --now rclone-tuxcloud.service
rm ~/.config/systemd/user/rclone-tuxcloud.service
systemctl --user daemon-reload
fusermount3 -uz ~/cloud; rmdir ~/cloud
rm -rf ~/.cache/rclone
sed -i '\|file://'"$HOME"'/cloud |d' ~/.config/gtk-3.0/bookmarks
rclone config delete tuxcloud           # only if dropping the remote entirely
```

## See Also

- [VPN.md](VPN.md) - WireGuard split tunnelling; `novpn-exec` if the VPN ever
  shadows the `10.8.40.0/24` route to the server.
