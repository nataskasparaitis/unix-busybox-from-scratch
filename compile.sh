#!/bin/bash
set -euo pipefail

echo "=== BusyBox full build ==="

SRC="/opt/task2/src"
VERSION="1.36.1"
ARCHIVE="busybox-${VERSION}.tar.bz2"
URL="https://busybox.net/downloads/${ARCHIVE}"

mkdir -p "$SRC"
cd "$SRC"


install_if_missing() {
    pkg="$1"
    cmd="$2"

    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "$cmd not found, installing $pkg..."
        sudo apt-get update
        sudo apt-get install -y "$pkg"
    else
        echo "$cmd already installed"
    fi
}

install_if_missing build-essential gcc
install_if_missing bzip2 bzip2
install_if_missing make make


if [ ! -f "$ARCHIVE" ]; then
    wget "$URL"
fi


if [ ! -d "busybox-${VERSION}" ]; then
    tar -xjf "$ARCHIVE"
fi

cd "busybox-${VERSION}"


make distclean || true
make defconfig

sed -i 's/CONFIG_TC=y/# CONFIG_TC is not set/' .config || true
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config


make -j"$(nproc)"

echo "=== BUILD COMPLETE ==="
file busybox
