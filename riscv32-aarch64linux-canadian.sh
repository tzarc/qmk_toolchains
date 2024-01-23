#!/usr/bin/env bash
# Copyright 2024 Nick Brassel (@tzarc)
# SPDX-License-Identifier: GPL-2.0-or-later

this_script=$(realpath "${BASH_SOURCE[0]}")
script_dir=$(dirname "${this_script}")
source "${script_dir}/common.bashinc"

build_one_help "$@"

build_one \
    --sample-name=riscv32-picolibc-elf \
    --vendor-name=unknown \
    --canadian-host=aarch64-unknown-linux-gnu \
    --binutils-plugins \
    --no-cross-gdb-python \
    "$@"