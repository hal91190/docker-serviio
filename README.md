# docker-serviio
A Dockerfile for Serviio media server

## Build
```
docker build -t="hal91190/serviio" .
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
    -v /mnt/MyBook:/medialibs \
    -v /var/log/serviio:/opt/serviio/log \
    --name="serviio" \
    hal91190/serviio
```

### In interactive mode
```
docker run -i -t \
    --net=host \
    -p 23423:23423 \
    -p 23424:23424 \
    -p 8895:8895 \
    -p 1900:1900/udp \
    -v /mnt/MyBook:/medialibs \
    -v /var/log/serviio:/opt/serviio/log \
    --name="serviio" \
    hal91190/serviio \
    /bin/bash
```

