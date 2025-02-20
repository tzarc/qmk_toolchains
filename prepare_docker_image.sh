#!/usr/bin/env bash
set -eEuo pipefail
docker rmi qmk_toolchains:builder || true
docker build -t qmk_toolchains:builder -f Dockerfile.linux-builder "$@" .