#!/usr/bin/env bash
# Copyright 2024 Nick Brassel (@tzarc)
# SPDX-License-Identifier: GPL-2.0-or-later

this_script="$PWD/$(basename ${BASH_SOURCE[0]})"
script_dir=$(dirname "${this_script}")
cd "$script_dir"
source "${script_dir}/common.bashinc"

build_one_help "$@"
respawn_docker_if_needed "$@"

if [[ $(uname -s) == "Linux" ]]; then
    extra_args="--tools-prefix=x86_64-qmk_bootstrap-linux-gnu-"
fi

build_one \
    --sample-name=x86_64-w64-mingw32 \
    --no-cross-gdb-python \
    --build-host-compile \
    ${extra_args:-} \
    "$@"