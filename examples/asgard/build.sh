#!/bin/bash

mkdir -p generated/asgard
mkdir -p generated/eureka

generate="bundle exec ../../bin/sdf-gen"

$generate global     asgard.yml > generated/asgard/global.conf
$generate gatekeeper asgard.yml > generated/asgard/gate.conf
$generate forwarder  asgard.yml > generated/asgard/forward-eureka.conf

$generate global     eureka.yml > generated/eureka/global.conf
$generate gatekeeper eureka.yml > generated/eureka/gate.conf
