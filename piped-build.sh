#!/bin/bash

set -e

# Install required packages to build
apk --no-cache add nginx yarn openjdk17-jdk go build-base libwebp-dev

# Piped frontend
export NODE_OPTIONS=--max_old_space_size=1536
echo "Compiling Piped frontend, might take a while"

rm -rf piped-fe.zip ./Piped-master/ ./piped-fe/
wget -O piped-fe.zip https://github.com/TeamPiped/Piped/archive/refs/heads/master.zip
unzip piped-fe.zip && mv Piped-master piped-fe && rm piped-fe.zip

pushd piped-fe
yarn install --prefer-offline
yarn build
rm -rf /usr/share/nginx/html/piped/
mkdir -p /usr/share/nginx/html/piped/ && mv dist/** /usr/share/nginx/html/piped/
# cp docker/nginx.conf ../config/piped-fe.conf
popd

rm -rf piped-fe /usr/local/share/.cache/yarn/

# Piped backend
wget -O piped-be.zip https://github.com/TeamPiped/Piped-Backend/archive/refs/heads/master.zip
unzip piped-be.zip && mv Piped-Backend-master piped-be

pushd piped-be
echo "Compiling Piped backend, might take a while"
./gradlew shadowJar
cp build/libs/piped-1.0-all.jar ../piped-server.jar
cp config.properties ../
popd

rm -rf ./.gradle ./piped-be

# ytproxy
echo "Compiling Piped ytproxy, might take a while"
wget -O piped-proxy.zip https://github.com/TeamPiped/http3-ytproxy/archive/refs/heads/main.zip
unzip piped-proxy.zip && mv http3-ytproxy-main piped-ytproxy

pushd piped-ytproxy
go build -ldflags "-s -w" main.go
popd

mv piped-ytproxy/main ./piped-proxy
rm -rf ./piped-ytproxy/ ./go/ ./.cache/go-build

apk del yarn openjdk17-jdk go build-base libwebp-dev