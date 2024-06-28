# Mixed-Deployment-Demo Project

## A deployment with infrastructure as code show case

### Overview

This is a showcase project showing the use of terraform / opentofu and kubernetes to
deploy a scalable webapp. The project consists of a backend database a frontend loadbalancer
and two different web applications, one written in Rust the other written in Java.
Both web applications do not show real useful functionality but rather basic
traits. Features have been implemented only once, resulting in the an implemented
feature of one application missing in the other.

The applications are containers scalable between two and ten as kubernetes pods.
They scale up and down within a timeframe of about 2 minutes. All external communication
is SSL encrypted, as well as the database communication. One application does SSL termination
while the other uses the load balancer to terminate the ssl connection. Configuration
is mostly done via .env files. There are many rough edges as deployments are usually not
really built for leight weight write once deploy everywhere, though infrastructure as
code suggest otherwise.

### Prerequisits

To run the project it is recommended to use an intel based ubuntu ideally 22.04.

Necessary installations:

- git
- docker and docker-compose
- minikube
- terraform

To access the weather data you need internet access. To see the security features
have a wildcard certificate ready. If you do not have one, create your own CA
and sign against it, adding the root certificate to your trusted store. Store the
cert and the key securely as root and give it a group ssl-cert. Add yourself to
the group to be able to run the project on the source code level.

Instructions how to do this is beyond the scope of this demo. Easiest way is to use
a vaild wildcard certificate.

Not strictly necessary but highly recommended:

- JDK 17
- Rust
- act
- postgres client
- curl
- hey

### Running the project

#### Secrets

First supply the necessary data for the `.env` files. Use `env.example` as templates.
You can also set environment variables via `export` or as `TF_<varname>`

You can inspect the project on several levels. The basic one is the source code level.

#### Source level

Have a postgres database ready at `pgdb`. Either install the database natively or simply
use

```bash
docker run -d --name pgdb -e POSTGRES_USER=<...> -e POSTGRES_PASSWORD=<...> postgres:latest
```

Be sure to add `127.0.0.1    pgdb` to your /etc/hosts file, or use any other means to
get the name resolved to localhost.

To run the Rust application simply type `cargo run --bin server` from the root of the
repository. You should now be able to access the website via `https://localhost:8443`
and the database via `psql -h localhost -U postgres -d postgres`, or equivalent names
you might have supplied with the `.env` files.

The Rust application creates the database and runs the migrations to create some tables.
It only displays a simple static mock website. To run the pipeline locally for rust use

```bash
act push
```

from the root of the repository. The pipeline simply compiles, and runs 0 tests.

Run Rust first as the Java application does not create a database and will fail if run first. Otherwise, log into postgres and create the postgres database.

To run the Java application cd into `java-server` and run `./mvnw spring-boot:run`. You can also
run `./mvnw clean install` to run one test. As consistent with a feature only implemented once,
there is no pipeline for the java application.
You can access the java application on `http://localhost:8080` to display a list of users or
use

```bash
curl -X GET http://localhost:8080/api/users
```

To add users use

```bash
curl -X POST http://localhost:8080/api/users -H "Content-Type: application/json" -d '{"name": "John Doe", "email": "john.doe@example.com"}'
```

For easier read `-X GET` and `-X POST` has been included here, though they are optional.
To modify or delete users log into the database.

You can also access weather information from the norvegian weather service. To access the data:

```bash
http://localhost:8080/weather?location=Moscow&utcHour=11
```

Fun fact:

You can also search for historical names. The api will return data for `Stalingrad, Konstantinopel and Koenigsberg whose geolocations belong to Volgograd, Istambul and Kaliningrad respectively.

#### Docker level

Again, first have your certificates ready. Since real certificates are used these should be own by root and be a member of the ssl-cert group. Locally you can add yourself to this group, but for docker, you do not know the id of the user. Thus an entrypoint script is used to take the cert and copy it over to another directory where the permissions are adopted for access of
the local docker user. The certs might have to be changed in permissions thus the copying over is necessary to avoid
changing of the group changing also the permissions on the host.

To run the application as a whole use

```bash
docker-compose build
docker-compose up -d
```

This will start four containers, one database, one application server each and one loadbalancer.
As all is on the same network there is not network isolation so you can access either directly
to each server or via the loadbalancer.

This part is a bit tricky. While possible to make it configurable, the amount of work would be enormous and not worth the time spent. Thus you have to edit `haproxy.cfg` to see the feature CNI based routing working:

Exchange the supplied domain names `web.common-work-education.co.uk` and `weather.common-work-education.co.uk` with your own common names. Add both of them to `/etc/hosts` to resolve to `localhost`.

You should now be able to access the weather app via `weather` subdomain and `web` via its subdomain. The mapping locally often runs into caching issues with chromium based browsers, so it is recommended to use
an incognito mode window for access.

If you look at the config you see how the challenge to get haproxy to route both level 4 and level 7 apps is to handle level 4 first and on hitting a level 7 domain route back to localhost on a different port where the ssl connection is terminated and then passed unencrypted to the application server.

#### Terraform level

The project can be automatically deployed to `minikube`. From the root of the repository change to `deployment\terraform` and run:

```bash
minitube tunnel
```

then

```bash
terraform init
terraform apply -auto-approve
```

Add `10.96.1.254` to your `/etc/hosts` file to resolve `weather` and `web` subdomains instead of localhost. You should after
deployment is finished be able to acess the app on the specified subdomains.

To inspect the scaling use `kubectl`

```bash
watch -n 1 kubectl get pods
```

will dynamically show you all pods currently deployed.

```bash
watch -n 1 kubectl get hpa
```

If you are fine with 30 seconds updates you can use `-w` or `--watch` instead. Since kubernetes does only support one
network card per pod, there is again no network isolation. This could be mitigated by adding network policies, however in
a real production environment actual subnets are used and multiple network cards are assigned to the instances.
You can remove the comments from the network policy terraform file, but this might break resource detection via autoscaler.
I had success by opening port `10250` but the risk of breaking anything by blocking wanted traffic is high. Therefore,
network policies have been disabed.

#### Troubleshooting

If something breaks, there are two likely reasons: The certificates and the values of the environment variables.
Inspect the config maps check the logs or log into the pod if something breaks to trouble shoot. `minikube` is
very comfortable in troubleshooting due to sensible and intuitive commands.

#### Known bugs

Credentials do not work for stats in minikube. Instead simply press enter as username and password are empty.
CNI does not reliably work on `Chromium` based browsers, use inkoginito mode instead to avoid caching issues.

#### Limitations

No scaling or redundancy has been implemented for database and loadbalancer. In reality they need to be doubled at least.
No network isolation or security is implemented. The applications have no real useful functionality.
