# Kopia desktop backups

Replaces Vorta. Snapshots to a remote `<server>` over LAN; `<server>` replicates the repo to B2.

```
sources ──► sftp://kopia@<server>/<sftp-base>/<host>   (every 3h, kopia scheduler)
                         │
                         └──► b2://<b2-bucket>/<host>/  (03:30, server-side CronJob)
```

Desktop does LAN-only. KopiaUI runs the scheduler + tray + notifications.
The server handles all off-site traffic.

## 0 → fully set up

```fish
# 1. Install + link. Idempotent. Seeds ~/.config/kopia/env.
cd ~/.dotfiles && ./install

# 2. Fill in KOPIA_PASSWORD + SFTP host/base (must match the remote sync secret)
$EDITOR ~/.config/kopia/env

# 3. Verify SSH to the server works
ssh -p 22 kopia@<server> hostname

# 4. Reconcile (one script does everything — see below)
~/.dotfiles/kopia/scripts/reconcile.sh

# 5. Start KopiaUI (also autostarts on next login via hypr/execs.conf)
kopia-ui
```

## reconcile.sh — the only script you need to run

`reconcile.sh` is idempotent and brings the desktop backup setup to the
declared state from whatever state it's in now:

1. Ensures the repo exists + is connected (creates via SFTP, or connects if already there)
2. Applies retention, compression, and schedule policy for `$USER@$hostname`
3. Rebuilds ignore rules from `ignore-patterns.txt`
4. Registers any new sources from `sources.txt` (first snapshot = registration)
5. Reports orphans (sources in Kopia that aren't in `sources.txt`) with the exact delete command

Run it:
- On a fresh machine after filling in env — it sets up everything
- After editing `sources.txt` or `ignore-patterns.txt` — it reconciles the diff
- After a failed/interrupted run — it picks up where it left off (Kopia dedup
  recognizes already-uploaded content blobs, so resume is fast)
- Any time you're unsure about state — it's safe to re-run

Ongoing daily snapshots are driven by Kopia's internal scheduler (inside
KopiaUI's server), not by this script. You only re-run reconcile when
*declarative state* changes.

## Restore

Via KopiaUI (tray → Snapshots), or CLI:

```fish
kopia --config-file=~/.config/kopia/sftp.config snapshot list --all
kopia --config-file=~/.config/kopia/sftp.config restore <id> /tmp/restore
kopia --config-file=~/.config/kopia/sftp.config mount <id> /tmp/kopia-mount
```

If `<server>` is gone: connect to B2 directly with the same password:
```fish
kopia repository connect b2 \
    --bucket=<b2-bucket> --prefix=<host>/ \
    --key-id=<endpoints app key id> --key=<endpoints app key>
```

## Retention + schedule

Every 3h (8/day). 10 latest / 24 hourly / 30 daily / 12 weekly / 24 monthly / 5 yearly.
All defined in `reconcile.sh` so every endpoint applies the same policy.

Sub-daily cadence means KopiaUI's success notifications get noisy. Open
Preferences → Notifications and disable "notify on success" (keep "notify
on failure"). The tray icon still shows overall health at a glance.

## Failure notifications

- Desktop: KopiaUI's Electron tray fires native notifications on snapshot
  errors when KopiaUI is running.
- Server side (sync-to-B2): your CronJob is responsible for surfacing
  failures (e.g. ntfy via `trap ERR`).
