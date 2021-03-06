FROM alpine:latest

ARG ARCH

RUN \
    CVERSION="latest/download" \
    ARCH=`uname -m` \
    && if [[ `uname -m` = "aarch64" ]]; then ARCH="arm64"; fi \
    && if [[ `uname -m` = "x86_64" ]]; then ARCH="amd64"; fi \
    && if [[ `uname -m` = "armhf" ]]; then ARCH="arm"; fi \
    && if [[ `uname -m` = "armv7l" ]]; then ARCH="arm"; fi \
    && if [[ `uname -m` = "ppc64le" ]]; then ARCH="386"; fi \
    && apk add --no-cache libc6-compat yq \
    && wget -O /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/$CVERSION/cloudflared-linux-$ARCH && chmod +x /usr/local/bin/cloudflared

RUN export ARCH=`uname -m`
ENV TZ="Asia/Bangkok"
ENV CVERSION="latest/download"
ENV CHECKARCH=${ARCH}

RUN mkdir -p /etc/cloudflared

#RUN cloudflared -v
RUN cloudflared update

CMD echo $credjson > /etc/cloudflared/credentials.json && echo $configjson | base64 -d > /etc/cloudflared/config.yml && cloudflared tunnel --config /etc/cloudflared/config.yml run

#COPY run.sh /
#RUN chmod a+x /run.sh

#CMD [ "/run.sh" ]