# SDF Generator

Generates Nginx configuration files for Conjur Software-Defined Firewall (SDF). 

`sdf-gen` supports three subcommands, each of which generates a config file which can be included in a 
global `nginx.conf`:

* **global** global Nginx configuration, such as the location of the “conjur” upstream service.
* **gatekeeper** a gatekeeper configuration, to intercept and authorize requests. Each service should have exactly 1 gatekeeper.
* **forwarder** obtains auth tokens and adds them to outbound requests. Each client service may have multiple forwarders; one for each external service that the client service will call.

Operation of `sdf-gen` is driven by a YAML configuration file. This configuration file has three sections:
`global`, `gatekeeper`, and `forward`. Each of these sections contains the metadata which is used by the 
corresponding subcommand. `global` and `gatekeeper` are each a single Hash of data; `forward` can be a list,
since a service may have multiple outbound forwarders.

## Example

**Asgard** is a Netflix open source program which launches and manages ec2-based services and applications.
**Eureka** is a service directory. Asgard and Eureka are designed to work together; in particular, Asgard
is a client of Eureka. The directory [examples/asgard](https://github.com/conjurinc/sdf-gen/tree/master/examples/asgard) contains SDF configuration
which protects Asgard and Eureka with gatekeepers, and forwards requests from Asgard to Eureka.

#### `global` section

Defines the remote hostname of the `conjur` service.

```yaml
global:
  conjur:
    hostname: conjur
```

#### `gatekeeper` section

Defines the inbound port and local protected service.

In addition, specifies the protected resource id which will be used for authorization checks.

```yaml
gatekeeper:
  port: 80
  service: unix:/tmp/nginx.socket fail_timeout=0
  conjur_account:  demo
  conjur_resource: webservice/production/asgard
```

#### `forward` section

A list of forwarders. Each one specifies a listen address, and a remote service to which outbound
requests will be sent.

```yaml
forward:
-  
  id: eureka
  listen: 127.0.0.2
  service: https://eureka
```

## Installation

    $ gem install sdf-gen

## Usage


```sh-session
$ sdf-gen help
NAME
    sdf-gen - SDF Nginx configuration generator

SYNOPSIS
    sdf-gen [global options] command [command options] [arguments...]

VERSION
    x.y.z

GLOBAL OPTIONS
    --help    - Show this message
    --version - Display the program version

COMMANDS
    forwarder       - Generate a forwarder
    forwarder-count - Count the number of forwarders in the config
    gatekeeper      - Generate a gatekeeper
    global          - Generate the global Nginx config file
    help            - Shows a list of commands or help for one command
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sdf-gen/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
