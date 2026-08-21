#!/usr/bin/env bash
# Copyright 2024-2026 Nick Brassel (@tzarc)
# SPDX-License-Identifier: GPL-2.0-or-later

set -eu

this_script="$PWD/$(basename ${BASH_SOURCE[0]})"
script_dir=$(dirname "${this_script}")
cd "$script_dir"

BASE_IMAGE=${BASE_IMAGE:-ghcr.io/tzarc/qmk_toolchains:base}
BUILDER_IMAGE=${BUILDER_IMAGE:-ghcr.io/tzarc/qmk_toolchains:builder}

# Keys double as the toolchain directory suffix; values are the build_toolchain.py selector args
declare -A target_args=(
    [linuxX64_qmk_bootstrap]='--target linuxX64 --variant qmk_bootstrap'
    [linuxX64]='--target linuxX64'
    [linuxARM64]='--target linuxARM64'
    [linuxRV64]='--target linuxRV64'
    [windowsX64]='--target windowsX64'
)

# Use gdb as it's the last step in the toolchain
declare -A check_files=(
    [linuxX64_qmk_bootstrap]=x86_64-qmk_bootstrap-linux-gnu-gdb
    [linuxX64]=x86_64-qmk-linux-gnu-gdb
    [linuxARM64]=aarch64-unknown-linux-gnu-gdb
    [linuxRV64]=riscv64-unknown-linux-gnu-gdb
    [windowsX64]=x86_64-w64-mingw32-gdb
)

docker build -t ${BASE_IMAGE} -f Dockerfile.base .

for target in "${!target_args[@]}"; do
    check_file=${check_files[$target]}
    if [ ! -x "toolchains/host_linuxX64-target_${target}/bin/${check_file}" ] && [ ! -x "toolchains/host_linuxX64-target_${target}/bin/${check_file}.exe" ]; then
        echo "Missing toolchain for ${target}, building..."
        ./build_toolchain.py --host linuxX64 ${target_args[$target]} --container-image=${BASE_IMAGE}
    fi
    tar acf qmk_toolchain-host_linuxX64-target_${target}.tar -C toolchains host_linuxX64-target_${target}
    zstdmt -T0 -19 --long --rm --force qmk_toolchain-host_linuxX64-target_${target}.tar
done

docker build -t ${BUILDER_IMAGE} -f Dockerfile.builder --build-arg BASE_CONTAINER=${BASE_IMAGE} .
