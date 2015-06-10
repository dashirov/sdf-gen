#!/bin/bash

ruby sdf.rb

cd webapp

sdf-gen global     sdf.yml > gatekeeper/nginx/conf/global.conf
sdf-gen gatekeeper sdf.yml > gatekeeper/nginx/conf/gate.conf

sdf-gen global    sdf.yml > backend/nginx/conf/global.conf
sdf-gen forwarder sdf.yml > backend/nginx/conf/forward.conf.template

docker-compose build
cd -

cd backend
sdf-gen global     sdf.yml > gatekeeper/nginx/conf/global.conf
sdf-gen gatekeeper sdf.yml > gatekeeper/nginx/conf/gate.conf

docker-compose build
cd -
