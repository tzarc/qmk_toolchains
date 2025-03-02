FROM ubuntu:noble AS extractor

RUN apt-get update && apt-get install -y xz-utils zstd
COPY qmk_toolchain*.tar.zst /tmp
RUN mkdir /qmk && ls -1 /tmp/qmk_toolchain*.tar.zst | xargs -I {} tar axf {} -C /qmk --strip-components=1

FROM ghcr.io/tzarc/qmk_toolchains:base AS base
COPY --from=extractor /qmk /qmk
