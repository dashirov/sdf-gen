#!/bin/bash

docker run -v $PWD/webapp/sdf.yml:/sdf.yml sdf-gen global sdf.yml > webapp/gatekeeper/nginx/conf/global.conf
docker run -v $PWD/webapp/sdf.yml:/sdf.yml sdf-gen global sdf.yml > webapp/backend/nginx/conf/global.conf
docker run -v $PWD/webapp/sdf.yml:/sdf.yml sdf-gen gatekeeper sdf.yml > webapp/gatekeeper/nginx/conf/gate.conf
docker run -v $PWD/webapp/sdf.yml:/sdf.yml sdf-gen forwarder -l @host_id@ -k @api-key@ sdf.yml > webapp/backend/nginx/conf/forward.conf

cd webapp
docker-compose build
cd -

docker run -v $PWD/backend/sdf.yml:/sdf.yml sdf-gen global sdf.yml > backend/gatekeeper/nginx/conf/global.conf
docker run -v $PWD/backend/sdf.yml:/sdf.yml sdf-gen gatekeeper sdf.yml > backend/gatekeeper/nginx/conf/gate.conf

cd backend
docker-compose build
cd -
