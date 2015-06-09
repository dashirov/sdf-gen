#!/bin/bash

generate="bundle exec ../../../bin/sdf-gen"

cd webapp

$generate global     sdf.yml > gatekeeper/nginx/conf/global.conf
$generate gatekeeper sdf.yml > gatekeeper/nginx/conf/gate.conf

$generate global    sdf.yml > backend/nginx/conf/global.conf
$generate forwarder sdf.yml > backend/nginx/conf/forward.conf.template

docker-compose build
cd -

cd backend
$generate global     sdf.yml > gatekeeper/nginx/conf/global.conf
$generate gatekeeper sdf.yml > gatekeeper/nginx/conf/gate.conf

docker-compose build
cd -
