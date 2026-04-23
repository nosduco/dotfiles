# Kopia desktop backups

Replaces Vorta. Snapshots to tux over LAN; tux replicates the repo to B2.

```
sources ──► sftp://kopia@tux/tank/data/backups/endpoints/<host>   (02:00, kopia scheduler)
                         │
                         └──► b2://tuxcloud-endpoints-backups/<host>/  (03:30, tux CronJob)
```

Desktop does LAN-only. KopiaUI runs the scheduler + tray + notifications.
Tux handles all off-site traffic.

## 0 → fully set up

```fish
# 1. Install + link. Idempotent.
cd ~/.dotfiles && ./install

# 2. Verify SSH to tux as kopia (add host to kopia-sftp-user ansible role if new)
ssh -p 22 kopia@tux hostname

# 3. Edit the env stub (./install seeded it from kopia/env.example)
$EDITOR ~/.config/kopia/env

# 4. One-time bootstrap: connects repo, applies policy, registers sources.
~/.dotfiles/kopia/scripts/bootstrap-repos.sh

# 5. Start KopiaUI (autostarts on login via hypr/execs.conf)
kopia-ui
```

After that, KopiaUI's scheduler takes a snapshot at 02:00 every day.
Tray icon shows status; Electron notifications fire on success/failure.
KopiaUI connects without prompting (password is persisted in gnome-keyring).

## What each script does

- `bootstrap-repos.sh` - makes sure the Kopia repo exists + is connected.
  No policy, no snapshots. Safe to re-run; no-ops if already connected.
- `apply-policies.sh` - reconciles retention, ignore rules, and sources
  against `sources.txt`. New sources get a one-time snapshot to register
  them (kopia's scheduler picks them up from there). Already-registered
  sources are left alone - incremental snapshots are the scheduler's job.
  Orphans (registered sources no longer in `sources.txt`) are logged
  with the exact `kopia snapshot delete` command to copy-paste.

## Editing sources / ignores

```fish
$EDITOR ~/.dotfiles/kopia/{sources.txt,ignore-patterns.txt}
~/.dotfiles/kopia/scripts/apply-policies.sh
```

Fast on subsequent runs: only *new* sources get snapshotted, known ones
are reconciled in-place. Triggering a snapshot manually is a KopiaUI
click or `kopia snapshot create <path>` away.

## Restore

Use KopiaUI (tray icon → Snapshots), or CLI:

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

## Retention

10 latest / 30 daily / 12 weekly / 24 monthly / 5 yearly. Set in `apply-policies.sh`.

## Schedule

Daily at 02:00 (via kopia policy `--snapshot-time=02:00 --snapshot-interval=24h`).
KopiaUI must be running for the scheduler to fire — it autostarts from
`hypr/execs.conf`. If you quit KopiaUI and miss a day, next snapshot runs when
you reopen it.
