#!/usr/bin/with-contenv bashio

mkdir -p /etc/cloudflared

#echo $(bashio::config 'credential_file_content') > /etc/cloudflared/credentials.json
#echo $(bashio::config 'config_file_content_base64') | base64 -d > /etc/cloudflared/config.yml
#echo $(bashio::config 'config_file_content') > /etc/cloudflared/config.yml

echo $credjson > /etc/cloudflared/credentials.json
echo $configjson | base64 -d > /etc/cloudflared/config.yml

#bashio::log.info "Running cloudflared update..."

#cloudflared update

if [ $CHECKARCH == "aarch64" ]
then
   export WOW=arm64
fi

if [ $CHECKARCH == "x86_64" ]
then
   export WOW=amd64
fi

if [ $CHECKARCH == "armhf" ]
then
   export WOW=arm
fi

if [ $CHECKARCH == "armv7l" ]
then
   export WOW=arm
fi

if [ $CHECKARCH == "ppc64le" ]
then
   export WOW=386
fi

echo "https://github.com/cloudflare/cloudflared/releases/$CVERSION/cloudflared-linux-$WOW"

wget -O /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/$CVERSION/cloudflared-linux-$WOW && chmod +x /usr/local/bin/cloudflared

#bashio::log.info "Running cloudflared tunnel..."

cloudflared tunnel --config /etc/cloudflared/config.yml --autoupdate-freq 1h run