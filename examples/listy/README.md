
## Global Build

Store the project dir:

```
$ project_dir=$PWD
```

Load the policy file

```
$ conjur policy load -c policy-sandbox.json policy.rb
```

Build the project.

* Generate sdf.yml
* Process sdf.yml into nginx configs
* Build docker pods

```
./build.sh
```

## Test the Backend

Test the backend using `conjur proxy`:

```
$ cd $project_dir/backend
$ conjur proxy -p 5000 http://$(boot2docker ip):8085 &
$ curl localhost:5000
{"list":[]}%                                                                    
$ curl -X POST localhost:5000 --data name="alice"
$ curl localhost:5000                            
{"list":["alice"]}%     
```

# Run the backend

Now that it's tested, stop the backend and restart it as a daemon.

```
$ docker-compose stop
$ docker-compose up -d
```

# Setup the webapp

Create the forwarder host:

```
$ cd $project_dir
$ policy=$(cat policy-sandbox.json | jsonfield policy)
$ conjur host create $policy/webapp-01 | tee webapp-01.json
$ conjur layer hosts add $policy/webapp $policy/webapp-01
$ host_id=$(cat webapp-01.json | jsonfield id)
$ host_api_key=$(cat webapp-01.json | jsonfield api_key)
```

Build the webapp pod:

```
$ cd $project_dir/webapp
$ docker-compose build
```

Build the identity container:

```
$ docker build -t webapp_identity identity
```

Run the identity container:

```
$ docker run \                                                 
   -d \       
   --name webapp_identity \
   -e CONJUR_AUTHN_LOGIN=host/$host_id \
   -e CONJUR_AUTHN_API_KEY=$host_api_key \
   webapp_identity
```

If you are using `boot2docker`, expose the backend port on the host:

```
$ VBoxManage controlvm boot2docker-vm natpf1 "expose-listy-backend,tcp,127.0.0.1,8085,,8085"
```

Now run the webapp:

```
$ docker-compose up
```

Start a `conjur proxy` to the webapp:

```
$ conjur proxy -p 5001 http://$(boot2docker ip):8080 &
```

`curl` to the webapp:

```
$ curl localhost:5001
```

