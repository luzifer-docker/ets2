#!/usr/bin/env bash
set -euo pipefail

# Install required packages
dpkg --add-architecture i386
apt-get update

# Accept EULA before unattended install
echo steam steam/license note '' | debconf-set-selections
echo steam steam/question select "I AGREE" | debconf-set-selections

apt-get install --no-install-recommends -y \
  ca-certificates \
  curl \
  libatomic1 \
  libx11-6 \
  rsync \
  steamcmd
rm -rf /var/lib/apt/lists/*

# Add user for running gameserver
useradd -d /home/steam -m -u 1000 steam
