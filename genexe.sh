#!/usr/bin/env bash
base=$(dirname $0)
file="$base/main"
cd $base
rm -rf "$base/dist/linux"
if [ -f $file ]; then
	rm $file
fi
echo "Compiling..."
raco exe main.rkt
echo "Creating distro..."
raco distribute "$base/dist/linux" $file
rm main
echo "Compressing package..."
racket zipper.rkt
cd "$base/dist/linux/bin"
echo "Done. Running program."
./main
