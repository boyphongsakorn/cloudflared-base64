FROM alpine:latest

ARG BUILD_ARCH
ARG ARCH

RUN echo `uname -m`
RUN echo ${ARCH}

RUN \
    CVERSION="latest/download" \
    ARCH="${BUILD_ARCH}" \
    && if [[ "${BUILD_ARCH}" = "aarch64" ]]; then ARCH="arm64"; fi \
    && if [[ "${BUILD_ARCH}" = "amd64" ]]; then ARCH="amd64"; fi \
    && if [[ "${BUILD_ARCH}" = "armhf" ]]; then ARCH="arm"; fi \
    && if [[ "${BUILD_ARCH}" = "armv7" ]]; then ARCH="arm"; fi \
    && if [[ "${BUILD_ARCH}" = "i386" ]]; then ARCH="386"; fi \
    && apk add --no-cache libc6-compat yq

ENV TZ="Asia/Bangkok"
ENV CVERSION="latest/download"
ENV CHECKARCH=${BUILD_ARCH}

RUN cloudflared -v
RUN cloudflared update

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]