#!/usr/bin/env bash
# Copyright 2024-2025 Nick Brassel (@tzarc)
# SPDX-License-Identifier: GPL-2.0-or-later

set -eu

this_script="$PWD/$(basename ${BASH_SOURCE[0]})"
script_dir=$(dirname "${this_script}")
cd "$script_dir"

BUILDER_IMAGE=${BUILDER_IMAGE:-qmk_toolchains:builder}

declare -A target_prefixes=(
    [baremetalARM]='arm'
    [baremetalAVR]='avr'
    [baremetalRV32]='riscv32'
)

# Use gdb as it's the last step in the toolchain
declare -A check_files=(
    [baremetalARM]='arm-none-eabi-gdb'
    [baremetalAVR]='avr-gdb'
    [baremetalRV32]='riscv32-unknown-elf-gdb'
)

declare -A host_suffixes=(
    [linuxX64]='native.sh'
    [linuxARM64]='aarch64linux-canadian.sh'
    [linuxRV64]='riscv64linux-canadian.sh'
    [macosARM64]='aarch64macos-canadian.sh'
    [macosX64]='x64macos-canadian.sh'
    [windowsX64]='win64-canadian.sh'
)

for target in "${!target_prefixes[@]}"; do
    prefix=${target_prefixes[$target]}
    for host in "${!host_suffixes[@]}"; do
        suffix=${host_suffixes[$host]}
        script="${prefix}-${suffix}"
        check_file=${check_files[$target]}
        if [ ! -x "toolchains/host_${host}-target_${target}/bin/${check_file}" ] && [ ! -x "toolchains/host_${host}-target_${target}/bin/${check_file}.exe" ]; then
            echo "Missing toolchain for ${target} on ${host}, building..."
            ./${script} --container-image=${BUILDER_IMAGE} --strip-toolchain
        fi
        if [ -x "toolchains/host_${host}-target_${target}/bin/${check_file}" ] || [ -x "toolchains/host_${host}-target_${target}/bin/${check_file}.exe" ]; then
            echo "Creating tarball for ${target} on ${host}..."
            tar acf qmk_toolchain-host_${host}-target_${target}.tar --sort=name -C toolchains host_${host}-target_${target}
            zstdmt -T0 -19 --long --rm --force qmk_toolchain-host_${host}-target_${target}.tar
        fi
    done
done
