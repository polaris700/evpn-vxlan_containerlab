FROM quay.io/frrouting/frr:10.0.0
LABEL maintainer "Porari"

SHELL ["/bin/bash", "-l", "-c"]

# Install packages
RUN apk update \
 && apk add tcpdump

# Setup FRRouting
RUN sed -i -e 's/=no/=yes/g' /etc/frr/daemons \
 && touch /etc/frr/vtysh.conf \
 && echo "service integrated-vtysh-config" >> /etc/frr/vtysh.conf \
 && mkdir /var/log/frr \
 && touch /var/log/frr/frr.log \
 && chmod 766 /var/log/frr/frr.log
