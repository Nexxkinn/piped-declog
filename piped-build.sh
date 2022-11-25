#!/bin/bash

set -e

#backing up old config
backup_name=$(date +%s)

if [ -d config ]; then
mv config config_$backup_name
fi

if [ -f config.properties ]; then
mv config config_$backup_name.properties
fi

# Install required packages to build
apk --no-cache add nginx yarn openjdk17-jdk cargo rust

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
unzip piped-be.zip && mv Piped-Backend-master piped-be && rm piped-be.zip

pushd piped-be
echo "Compiling Piped backend, might take a while"
./gradlew shadowJar
cp build/libs/piped-1.0-all.jar ../piped-server.jar
cp config.properties ../
popd

rm -rf ./.gradle ./piped-be

# Piped-proxy
wget -O piped-proxy.zip https://github.com/TeamPiped/piped-proxy/archive/refs/heads/main.zip
unzip piped-proxy.zip && mv piped-proxy-main piped-ytproxy && rm piped-proxy.zip

pushd piped-ytproxy
echo "Compiling Piped proxy, might take a while"
CARGO_HOME=$(pwd)/.cargo cargo build --release
mv target/release/piped-proxy ../
popd
rm -rf ./piped-ytproxy/

# ytproxy
# echo "Compiling Piped proxy, might take a while"
# wget -O piped-proxy.zip https://github.com/TeamPiped/http3-ytproxy/archive/refs/heads/main.zip
# unzip piped-proxy.zip && mv http3-ytproxy-main piped-ytproxy

# pushd piped-ytproxy
# go build -ldflags "-s -w" main.go
# popd

mv piped-ytproxy/main ./piped-proxy
rm -rf ./piped-ytproxy/

apk del yarn openjdk17-jdk rust cargo

cat << EOF
The script has finished compiling the following list:
- piped frontend
- piped backend
- piped proxy

If you are running this script on the clean environment,
please run piped-install.sh for nginx and database setup.

Otherwise, please replace the new config with the backup
one if you have your own configuration.
EOF