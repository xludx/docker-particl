# ludx/particl

A Particl docker image.

## Usage

* Docker installed and running
  * [install Docker](https://docs.docker.com/engine/installation/)
* Server with at least 1GB memory


## Quickstart

To start Particl instance running the latest version:

```sh
# create Particl data folder
$ mkdir /home/user/.particl

$ docker run -d --restart=always \
    -p 51738:51738 \
    -v /home/user/.particl:/root/.particl \
    --name particld ludx/particl
```

## Configuration

TODO

## Building

make build

## Debugging

View logs

```sh
docker logs particld
```

Attach bash into running container to debug running particld

```sh
docker exec -it particld bash -l
kontena container exec kontena-agent1/particl-stack.particld-1 bash -l
```
