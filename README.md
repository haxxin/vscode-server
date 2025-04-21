
# vscode-server

Visual Studio Code IDE server uplink.

- [docker.fs1.home: code tunnel](http://docker.fs1.home:8010)

## usage

- [Remote Code Tunnels][0]
- web UI for vscode instance

### bootstrap

```sh
git clone "https://github.com/i8degrees-dockerfiles/vscode-server.git \
    vscode-server.git"
cd "vscode-server.git" || exit 2
```

```sh
# initial image compilation; see build.sh
docker compose build
# external network declaration
docker network create proxy
```

### service control

#### build

Every time you make a modification to this project's
`Dockerfile`, we must rebuild the distribution image
that is used to boot the service in `compose.yml`.

```sh
docker compose build
```

#### service start

Once you have an image built, when you wish to begin
running the service(s) defined in `compose.yml`, issue
the `up` command.

```sh
docker compose up -d
```

Note that the service will remain in this state upon
a restart of the underlying OS. This also applies to
when you restart the Docker service itself.

The `restart` attribute in your `compose.yml` can
modify whether or not this occurs;

- `unless-stopped` -- *...*

- `always` -- This will always restart the service in
question, regardless of if the service is in an error
state upon startup (system or Docker service).

- `never` -- This will prevent the service from
automatically restarting under any condition. This means
you are responsible for `compose up -d` yourself of the
service.

- `on-failure` -- This means that the service will only
be restarted upon failure or error conditions present.

This may not be an exhaustive list of control flow options.
Please refer to the official documentation for Docker compose
syntax for the most up-to-date information.

##### service start from scratch

Often times, the `up` command will automatically detect
when the service image needs to be "refreshed", but
when you are testing your services, such as during
the packaging or distribution software development phase,
it can be helpful to know that you are starting with
a fresh build and do not have any lingering data around.

This is also useful when debugging a service and need to
know beyond a doubt that any such modifications you have
made are being taken effect.

```sh
docker compose up -d --force-recreate
```

##### service query

List the status of the services inside of your project directory.

```sh
docker compose ps
```

#### service stop

Shut down your service(s) defined in the `compose.yml` project.

```sh
docker compose down
#docker compose down --remove-orphans
```

#### service logs

Getter for the service logs -- this is a capture of the service's
`stdout` or standard output.

```sh
docker compose logs
docker compose logs --since=5m
docker compose logs --since=24h -f
```

#### debugging

##### attach to shell

Once the container is live -- and not restarting due to an error --
sometimes it is useful to examine the working state of the container
that you have brought up.

This is often times useful when debugging control flow, filesystem state or even
when you need to install additional packages (assuming you have privileges 
setup to handle this).

```sh
docker exec -it vscode-server-1 bash
#docker exec -it vscode-server-1 sh
```

##### push to hub

**NOTE(JEFF):** This action requires you to be logged into the registry
in question -- defaults to hub.docker.com.

The final distribution image of your service, including the
build layers (whether they are from your own `Dockerfile` or
inherited from another container), can be stored in a 
[registry][]. The default is <https://hub.docker.com> and
there are also many other third-party options, including the
ability to self-host your own.

```sh
docker push <user/service:tag>
#docker compose push
```

##### pull from hub

```sh
docker pull <user/service:tag>
#docker compose pull
```

##### login

```sh
docker login -u <username>
#docker logout
```

## reference documents

[0]: https://code.visualstudio.com/docs/remote/tunnels
[10]:
[90]:
[100]:
[110]:

