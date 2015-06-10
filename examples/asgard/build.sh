#!/bin/bash

mkdir -p generated/asgard
mkdir -p generated/eureka

sdf-gen global     asgard.yml > generated/asgard/global.conf
sdf-gen gatekeeper asgard.yml > generated/asgard/gate.conf
sdf-gen forwarder  asgard.yml > generated/asgard/forward-eureka.conf

sdf-gen global     eureka.yml > generated/eureka/global.conf
sdf-gen gatekeeper eureka.yml > generated/eureka/gate.conf
