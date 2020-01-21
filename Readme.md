# Statping

Status Page for monitoring your websites and applications with beautiful graphs, analytics, and plugins. Run on any type of environment..

# Usage

**Docker Create**

```
docker create \
  --name=statping \
  -v <path to data>:/app \
  -e PGID=<gid> -e PUID=<uid> \
  -e TZ=<timezone> \
  -e SKIPUPDATE='no' \       
  eafxx/traktarr

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
docker run -d --name='Statping' --net='bridge' -e TZ="Europe/London" -e HOST_OS="Unraid" -e 'PUID'='99' -e 'PGID'='100' -e 'SKIPUPDATE'='no' -p '8366:8080/tcp' -v '/mnt/cache/appdata/statping/config':'/app':'rw' 'eafxx/statping' 

```
**NOTE:** On the first run, the container will create a config.json in the /config folder and it will exit, add in your details for Sonarr, Radarr and your Trakt app info (complete step 2 first), then start or restart the container.

## Parameters

Container images are configured using parameters passed at runtime (such as those above). 

| Parameter | Function |
| :----: | --- |
| `-e PUID=99` | For UserID - see below for explanation |
| `-e PGID=100` | For GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London |
| `-e SKIPUPDATE=no` | Skip auto-update of the Statping app on container restarts, options: yes/no, default: no |
| `-v /app` | Contains all relevant configuration files. |

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