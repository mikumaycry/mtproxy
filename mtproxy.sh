#!/bin/sh

set -e

secret_file=/data/secret
proxy_secret_file=/data/proxy_secret
proxy_multi_file=/data/proxy_multi
proxy_port="${PORT:-8888}"
proxy_http_port="${HTTPPORT:-8443}"
proxy_domain="${DOMAIN:-cloudflare.com}"

if [ ! -f $secret_file ]; then
    head -c 16 /dev/urandom | xxd -ps |cat > $secret_file
fi

secret=$(cat $secret_file)

if [ ! -f $proxy_secret_file ]; then
    curl -s https://core.telegram.org/getProxySecret -o $proxy_secret_file
    echo "proxy_secret generated: $proxy_secret_file"
fi

if [ ! -f $proxy_multi_file ]; then
    curl -s https://core.telegram.org/getProxyConfig -o
    echo "proxy_multi generated: $proxy_multi_file"
fi

/usr/bin/mtproto-proxy -u root -p $proxy_port -H $proxy_http_port -S $secret --aes-pwd $proxy_secret_file $proxy_multi_file -D $proxy_domain
