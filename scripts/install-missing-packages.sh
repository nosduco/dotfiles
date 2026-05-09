#!/bin/bash
# Install only packages from packages.txt that are not already present.
# Never upgrades anything: out-of-date packages are left alone, and updates
# are a deliberate `paru -Syu` action separate from `./install`.
set -e

PKG_FILE="$(dirname "$0")/../packages.txt"

# pacman -T prints names of unsatisfied (not-installed) packages and exits
# nonzero when any are missing - swallow the exit code and read stdout.
missing=$(grep -v '^#' "$PKG_FILE" | grep -v '^$' | xargs pacman -T 2>/dev/null || true)

if [ -z "$missing" ]; then
  echo "All packages already installed."
  exit 0
fi

echo "Installing missing packages:"
echo "$missing" | sed 's/^/  /'
paru -S --needed --noconfirm $missing
