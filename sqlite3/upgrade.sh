#!/usr/bin/env bash
fatal() {
  echo "FATAL ERROR: $*" >&2
  exit 1
}

dir=$(mktemp -d)
mkdir -p "$dir"
trap 'rm -fr "$dir"' EXIT

[[ -s upgrading.md ]] || fatal "This script must be run from the 'sqlite3' subdirectory"
src="$(pwd)"
[[ $(file "$1") == *Zip\ archive* ]] || fatal "'$1' is not a Zip archive"

set -e

unzip "$1" -d "$dir"
cd "${dir}"/sqlite-src-*
CFLAGS='-DSQLITE_ENABLE_UPDATE_DELETE_LIMIT=1' ./configure
make sqlite3.c
cp sqlite3.c sqlite3.h "$src"
