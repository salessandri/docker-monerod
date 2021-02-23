# Full Monero Node for Docker

[![Docker Stars](https://img.shields.io/docker/stars/salessandri/monerod.svg)](https://hub.docker.com/r/salessandri/monerod/)
[![Docker Pulls](https://img.shields.io/docker/pulls/salessandri/monerod.svg)](https://hub.docker.com/r/salessandri/monerod/)
[![ImageLayers](https://images.microbadger.com/badges/image/salessandri/monerod.svg)](https://microbadger.com/images/salessandri/monerod)

Docker image that runs a full Monero node node in a container for easy deployment.

The service runs as user id `1337`, this has some implications when mounting host directories on it.

## Quick Start

In order to setup a Monero node with the default options perform the following steps:

1. Create a volume for the data.

```
docker volume create --name=monerod-data
```

All the data the service needs to work will be stored in the volume.
The volume can then be reused to restore the state of the service in case the container needs to be recreated (in case of a host restart or when upgrading the version).

2. Create and run a container with the `monerod` image.

```
docker run -d \
    --name monerod-node \
    -v monerod-data:/home/monero/.bitmonero \
    -p 18080:18080 \
    -p 18081:18081 \
    --restart unless-stopped \
    salessandri/monerod:latest
```

This will create a container named `monerod-node` which gets the host's ports 18080 and 18081 forwarded to it.
Also this container will restart in the event it crashes or the host is restarted.

3. Inspect the output of the container by using docker logs

```
docker logs -f monerod-node
```

## Configuration Customization

### Mounting a `bitmonero.conf` file on `/home/monero/.bitmonero/bitmonero.conf`

If one wants to write their own `bitmonero.conf` and have it persisted on the host but keep all the
monero data inside a docker volume one can mount a file volume on `/home/monero/.bitmonero/bitmonero.conf` **after** the mounting of the data volume.

_Note: Make sure the file is readable by UID 1337_

Example:
```
docker run -d \
    --name monerod-node \
    -v monerod-data:/home/monero/.bitmonero \
    -v /etc/bitmonero.conf:/home/monero/.bitmonero/bitmonero.conf \
    -p 18080:18080 \
    -p 18081:18081 \
    --restart unless-stopped \
    salessandri/monerod:latest
```

### Have a `bitmonero.conf` in the data directory

Instead of using a docker volume for the data, one can mount directory on `/home/monero/.bitmonero/` for the container to use as the data directory.
If this directory has a `bitmonero.conf` file, this file will be used.

Just create a directory in the host machine (e.g. `/var/monero-data`) and place your `bitmonero.conf` file in it.
Then, when creating the container in the `docker run`, instead of naming a volume to mount use the directory.

Prior using, make sure that the directory as well as the file are owned by UID 1337. Otherwise the service will not be able to write data to it.

```
mkdir /var/monero-data
vim /var/monero-data/bitmonero.conf
sudo chown -R 1337:1337 /var/monero-data

docker run -d \
    --name monerod-node \
    -v /var/monero-data:/home/monero/.bitmonero \
    -p 18080:18080 \
    -p 18081:18081 \
    --restart unless-stopped \
    salessandri/monerod:latest
```
