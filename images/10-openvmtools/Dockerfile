FROM alpine:3.11.2 AS builder

RUN apk --no-cache add alpine-sdk coreutils cmake \
  && adduser -G abuild -g "Alpine Package Builder" -s /bin/ash -D builder \
  && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && mkdir /packages \
  && chown builder:abuild /packages \
  && mkdir -p /var/cache/apk \
  && ln -s /var/cache/apk /etc/apk/cache

COPY open-vm-tools/ /home/builder/package

USER builder

WORKDIR /home/builder/package

RUN mkdir -p /home/builder/.abuild && \
    abuild-keygen -a -i -n && \
    abuild-apk update && \
    sudo chown -R builder:abuild /home/builder/package && \
    sudo chown -R builder:abuild /packages && \
    abuild -r

FROM alpine:3.11.2

COPY --from=builder /home/builder/packages/builder/x86_64 /apk-ros/x86_64

RUN apk update && \
        # apk --no-cache add net-tools iproute2 sudo fuse && \
        apk --no-cache add --repository /apk-ros open-vm-tools --allow-untrusted && \
        mkdir -p /mnt/hgfs && \
        rm -rf /apk-ros && \
        rm /var/cache/apk/*

ENTRYPOINT ["/usr/bin/ros", "entrypoint"]

RUN addgroup -g 1100 rancher && \
    addgroup -g 1101 docker && \
    addgroup -S sudo && \
    adduser -D -u 1100 -g rancher -G sudo -s /bin/bash rancher && \
    adduser rancher docker && \
    adduser -D -u 1101 -g docker -G sudo -s /bin/bash docker && \
    adduser docker docker && \
    adduser docker sudo && \
    sed -i 's/rancher:!/rancher:*/g' /etc/shadow && \
    sed -i 's/docker:!/docker:*/g' /etc/shadow && \
    echo '## allow password less for rancher user' >> /etc/sudoers && \
    echo 'rancher ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo '## allow password less for docker user' >> /etc/sudoers && \
    echo 'docker ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    echo "docker:tcuser" | chpasswd
