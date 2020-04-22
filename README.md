# [eafxx/statping](https://hub.docker.com/r/eafxx/statping)

- PUID/PGID support
- Updates app on container restart (can disable)

Status Page for monitoring your websites and applications with beautiful graphs, analytics, and plugins. Run on any type of environment.

# Docker

**Tags**

| Tag      | Description                          | Build Status                                                                                                | 
| ---------|--------------------------------------|-------------------------------------------------------------------------------------------------------------|
| latest | stable                 | ![Docker Build Master](https://github.com/elmerfdz/docker-statping/workflows/Docker%20Build%20Master/badge.svg) | 
| dev | development, pre-release      | ![Docker Build Dev](https://github.com/elmerfdz/docker-statping/workflows/Docker%20Build%20Dev/badge.svg)     |
| exp | experimental, unstable        | ![Docker Build Exp](https://github.com/elmerfdz/docker-statping/workflows/Docker%20Build%20Exp/badge.svg)   | 

**Docker Create**

```
docker create \
  --name=statping \
  -v <path to data>:/app \
  -e PGID=<gid> -e PUID=<uid> \
  -e TZ=<timezone> \
  -e SKIPUPDATE='no' \       
  eafxx/statping

```

OR

**Docker Compose**

```
    statping:
        container_name: statping
        image: eafxx/statping
        volumes:
            - <path to data>:/app
        environment:
            - PUID=<uid>
            - PGID=<gid>        
            - TZ=<timezone>
	    - SKIPUPDATE=no
```

OR 

**Docker Run**

```
docker run -d --name='Statping' --net='bridge' -e TZ="Europe/London" -e 'PUID'='99' -e 'PGID'='100' -e 'SKIPUPDATE'='no' -e 'VERBOSE'='1' -e 'ENV'='/app/.env' -p '8366:8080/tcp' -v '/mnt/cache/appdata/statping/config':'/app':'rw' 'eafxx/statping' 

```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). 

| Parameter | Function |
| :----: | --- |
| `-e PUID=99` | For UserID - see below for explanation |
| `-e PGID=100` | For GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London |
| `-e SKIPUPDATE=no` | Skip auto-update of the Statping app on container restarts, options: yes/no, default: no |
| `-e VERBOSE=1` | 1-4, display more logs in verbose mode (optional)  |
| `-e env=/app/.env` | .env file to set as environment [variables](https://github.com/hunterlong/statping/wiki/Environment-Variables) while running server (optional) |
| `-v /app` | Contains all relevant configuration files |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

# Project Source
https://github.com/hunterlong/statping
