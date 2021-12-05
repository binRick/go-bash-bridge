#!/usr/bin/env bash
set -e
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
export PATH=$PATH:$(pwd)/bin
START_DIR="$(pwd)"
source ../.envrc

cd ../.
find . -type f |grep Makefile|grep src/dist -v|grep bash-5 -v
