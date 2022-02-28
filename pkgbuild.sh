#!/usr/bin/env bash

set -euo pipefail

pacman -Syu --noconfirm --needed base-devel

echo "nobody ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
visudo -c
chmod -R a+rw .

baseDir="$PWD"
[ -n "$INPUT_PKGDIR" ] && inBaseDir=true || inBaseDir=false
cd "${INPUT_PKGDIR:-.}"
oldFiles=$(find -H "$PWD" -not -path '*.git*')

sudo -u nobody makepkg -s --noconfirm

sudo -u nobody makepkg --printsrcinfo > .SRCINFO
echo "::set-output name=srcInfo::.SRCINFO"
[ $inBaseDir = false ] && mv .SRCINFO /github/workspace

pkgFile=$(sudo -u nobody makepkg --packagelist)
relPkgFile="$(realpath --relative-base="$baseDir" "$pkgFile")"
echo "::set-output name=pkgFile::$relPkgFile"
[ $inBaseDir = false ] && mv "$pkgFile" /github/workspace

newFiles=$(find -H "$PWD" -not -path '*.git*')
mapfile -t toRemove < <(printf '%s\n%s\n' "$newFiles" "$oldFiles" | sort | uniq -u)
rm -rf "${toRemove[@]}"
