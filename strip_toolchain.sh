#!/usr/bin/env bash

set -eEuo pipefail

this_script="$PWD/$(basename ${BASH_SOURCE[0]})"
script_dir=$(dirname "${this_script}")
cd "$script_dir"
source "${script_dir}/common.bashinc"

if [ -z "${1}" ] || [ -z "${2}" ]; then
    echo "Usage: ${this_script} <path-to-toolchain-dir> <path-to-build-dir>"
    exit 1
fi

toolchain_dir="${1}"
build_dir="${2}"

if [[ ! -d "${toolchain_dir}" ]]; then
    echo "Error: ${toolchain_dir} is not a directory"
    exit 1
fi

if [[ ! -d "${build_dir}" ]]; then
    echo "Error: ${build_dir} is not a directory"
    exit 1
fi

# Find the host tools path
host_tools_path=$(find "${build_dir}" -type d -name 'bin' -path '*/.build/HOST-*/buildtools/bin' -print -quit)

# Work out the toolchain prefix
toolchain_prefix=$(find "${toolchain_dir}/bin" -type f -name '*-gcc*' -exec basename '{}' \; 2>/dev/null | head -n1 | sed -e 's@gcc.*$@@g')

# Strip binaries
find "${toolchain_dir}" -type f \
    -name '*.o' -or -name '*.a' \
    | xargs -n 1 -P $(nproc) ${host_tools_path}/${toolchain_prefix}strip --strip-debug \
    || true

find "${toolchain_dir}" -type f \
    -name '*.a' \
    | xargs -n 1 -P $(nproc) ${host_tools_path}/${toolchain_prefix}ranlib \
    || true