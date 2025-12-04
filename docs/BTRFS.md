# Snapper + Btrfs Setup (Arch Linux)

Assumes btrfs with subvolumes (`@`, `@home`, etc.) on LUKS.

## 1. Install

```bash
sudo pacman -S snapper snap-pac
```

## 2. Create @snapshots subvolume

```bash
sudo mount -o subvolid=5 /dev/mapper/<your-luks-device> /mnt
sudo btrfs subvolume create /mnt/@snapshots
sudo umount /mnt
```

## 3. Add to fstab

```bash
sudo mkdir -p /.snapshots
```

Add to `/etc/fstab`:

```
/dev/mapper/<your-luks-device> /.snapshots btrfs subvol=/@snapshots,noatime,compress=zstd 0 0
```

```bash
sudo mount -a
```

## 4. Create snapper config

```bash
sudo umount /.snapshots
sudo rmdir /.snapshots
sudo snapper -c root create-config /
sudo btrfs subvolume delete /.snapshots
sudo mkdir /.snapshots
sudo mount -a
sudo chmod 750 /.snapshots
```

## 5. Edit retention (optional)

Edit `/etc/snapper/configs/root`:

```ini
TIMELINE_MIN_AGE="1800"
TIMELINE_LIMIT_HOURLY="5"
TIMELINE_LIMIT_DAILY="7"
TIMELINE_LIMIT_WEEKLY="4"
TIMELINE_LIMIT_MONTHLY="0"
TIMELINE_LIMIT_YEARLY="0"
NUMBER_LIMIT="50"
```

## 6. Enable timers

```bash
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
```

## 7. Verify

```bash
sudo snapper -c root list
```

---

## Usage

```bash
# List snapshots
sudo snapper -c root list

# See changes since snapshot N
sudo snapper -c root status N..0

# Rollback to before snapshot N
sudo snapper -c root undochange N..0

# Browse snapshot
ls /.snapshots/N/snapshot/
```
