# docker-serviio
A Dockerfile for Serviio media server

## Build
```
docker build -t="hal91190/serviio:1.5.2" .
```

## Run
### As a daemon
```
docker run -d \
    --net=host \
    -p 23423:23423 \
    -p 23424:23424 \
    -p 8895:8895 \
    -p 1900:1900/udp \
    -v /mnt/mybook:/medialibs \
    -v /var/lib/serviio:/opt/serviio/library \
    -v /var/log/serviio:/opt/serviio/log \
    --restart=always \
    --name="serviio" \
    hal91190/serviio:1.5.2
```

### In interactive mode
```
docker run -i -t \
    --net=host \
    -p 23423:23423 \
    -p 23424:23424 \
    -p 8895:8895 \
    -p 1900:1900/udp \
    -v /mnt/mybook:/medialibs \
    -v /var/lib/serviio:/opt/serviio/library \
    -v /var/log/serviio:/opt/serviio/log \
    --name="serviio" \
    hal91190/serviio:1.5.2 \
    /bin/bash
```

