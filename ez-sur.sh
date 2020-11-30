#!/usr/bin/env bash

fail() {
  echo "$1" 1>&2

  exit 1
}

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo -e "Downloading macOS"
curl -#fLo \
  "$HOME/.ez-sur/macOS_20B50.pkg" \
  --create-dirs http://swcdn.apple.com/content/downloads/19/41/001-83532-A_LN5NT1FB2Z/o4zodwe2nhyl7dh6cbuokn9deyfgsiqysn/InstallAssistant.pkg || \
  fail "Failed to download macOS installer"

echo -e "Decompressing macOS installer"
sudo -S installer \
  -pkg "$HOME/.ez-sur/macOS_20B50.pkg" \
  -target / || \
  fail "Failed to decompress macOS installer"

echo -e "Creating install media"
sudo /Applications/Install\ macOS\ Big\ Sur.app/Contents/Resources/createinstallmedia \
  --volume /Volume/bigsur \
  --nointeraction || \
  fail "Failed to create install media"

echo -e "Downloading big-sur-micropatcher"
curl -#fLo \
  "$HOME/.ez-sur/big-sur-micropatcher_0.5.1.zip" \
  --create-dirs https://github.com/barrykn/big-sur-micropatcher/archive/v0.5.1.zip || \
  fail "Failed to download big-sur-micropatcher"

echo -e "Decompressing big-sur-micropatcher"
unzip \
  "$HOME/.ez-sur/big-sur-micropatcher_0.5.1.zip" \
  -d "$HOME/.ez-sur" || \
  fail "Failed to decompress big-sur-micropatcher"

echo -e "Patching installer media"
cd "$HOME/.ez-sur/big-sur-micropatcher-0.5.1" || \
  fail "Failed to find big-sur-micropatcher folder"

echo -e "Running micropatcher.sh"
./micropatcher.sh

echo -e "Running install-setvars.sh"
./install-setvars.sh
