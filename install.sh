#!/bin/sh

header="$(echo \#\!\/bin\/sh)"
dir="$(pwd)"
printf $header"\n\ndir="$dir"\n" | cat - emailXKCD.sh > temp && mv temp emailXKCD.sh
