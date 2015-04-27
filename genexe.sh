#!/usr/bin/env bash
base=$(dirname $0)
file="$base/src/main"
cd $base
rm -rf "$base/dist/linux"
echo "Compiling..."
raco exe "src/main.rkt"
echo "Creating distro..."
mkdir -p "$base/dist/linux"
raco distribute "$base/dist/linux" $file
echo "Compressing package..."
racket "$base/compress.rkt"
rm -rf "src/main"
cd "$base/dist/linux/bin"
echo "Done. Running program."
./main
