#!/bin/sh

PREFIX="$1"
IN="$2"
OUT="$3"

(
	cat "$PREFIX"
	convert "$IN" -endian MSB rgb:- |
	hexdump -v -e '24/1 "1%02X ""\n"'
) > "$OUT"
