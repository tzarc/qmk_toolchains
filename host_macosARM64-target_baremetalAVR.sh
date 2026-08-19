#!/usr/bin/env bash
# Copyright 2024-2026 Nick Brassel (@tzarc)
# SPDX-License-Identifier: GPL-2.0-or-later
exec "$(dirname "${BASH_SOURCE[0]}")/build_toolchain.py" --host macosARM64 --target baremetalAVR "$@"
