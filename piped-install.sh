#!/bin/bash

apk add --no-cache postgresql14 nginx

# Nginx
mkdir -p /etc/nginx/conf.d
mkdir -p /etc/nginx/snippets

rm -rf ./config/
cp -r config_template config 

# this command below won't do anything

# echo "Enter a hostname for the Frontend (eg: piped.kavin.rocks):" && read -r frontend
# echo "Enter a hostname for the Backend (eg: pipedapi.kavin.rocks):" && read -r backend
# echo "Enter a hostname for the Proxy (eg: pipedproxy.kavin.rocks):" && read -r proxy

# sed -i "s/FRONTEND_HOSTNAME/$frontend/g" config/*
# sed -i "s/BACKEND_HOSTNAME/$backend/g" config/*
# sed -i "s/PROXY_HOSTNAME/$proxy/g" config/*

rm /etc/nginx/nginx.conf

ln -sf $(pwd)/config/piped*.conf /etc/nginx/conf.d/
ln -sf $(pwd)/config/nginx.conf /etc/nginx/nginx.conf
ln -sf $(pwd)/config/ytproxy.conf /etc/nginx/snippets/ytproxy.conf

# Postgres

sudo -u postgres initdb --username=piped -A scram-sha-256 --pwfile=<(echo changeme) --pgdata="/var/lib/postgresql/14/data/"
psql -U piped -c "create database piped;"