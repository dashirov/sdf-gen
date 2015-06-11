#!/usr/bin/env ruby

require 'rubygems'
require 'conjur/cli'
require 'uri'
require 'json'

Conjur::Config.load
Conjur::Config.apply

policy = JSON.load(File.read(File.expand_path('../policy-sandbox.json', __FILE__)))
policy_id = policy['policy']
hostname = URI.parse(Conjur.configuration.appliance_url).host

File.write File.expand_path('../backend/sdf.yml', __FILE__), <<SDF
global:
  conjur:
    hostname: #{hostname}

gatekeeper:
  port: 80
  service: service:4567
  conjur_account:  #{Conjur.configuration.account}
  conjur_resource: webservice/#{policy_id}/backend
SDF

File.write File.expand_path('../webapp/sdf.yml', __FILE__), <<SDF
global:
  conjur:
    hostname: #{hostname}

gatekeeper:
  port: 80
  service: service:4567
  conjur_account:  #{Conjur.configuration.account}
  conjur_resource: webservice/#{policy_id}/webapp

forward:
  backend:
    service: backend:80
SDF
