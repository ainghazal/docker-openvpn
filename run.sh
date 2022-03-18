#!/usr/bin/env bash

docker run --cap-add=NET_ADMIN \
-v openvpn_conf1:/opt/Dockovpn \
-p 1194:1194/udp -p 8080:8080/tcp \
--rm \
--env-file=.env \
--name=ovpn1 \
ainghazal/openvpn:latest
