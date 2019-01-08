FROM ubuntu:bionic

MAINTAINER Someguy123 (https://github.com/someguy123)

####
#
# Docker Networking Toolkit
#
#     Official Github: https://github.com/Someguy123/docker-networktools
#     by @someguy123
#
# Ubuntu 18.04 LTS with various networking tools pre-installed, for debugging networks.
# Originally developed for GNS3 (network prototyping tool), for troubleshooting and testing
# your GNS3 topology (https://www.gns3.com)
#
####

####
# Packages included
####
# bash-completion   - to make bash tab completion better
# command-not-found - when you type a command that doesn't exist, it informs you of which package a command is in
# mtr-tiny      - fast and easy to read realtime traceroutes for both IPv4 and IPv6 (tiny version skips all the GTK bloat)
# dnsutils      - provides tools such as `dig` and `nslookup` for DNS debugging
# net-tools     - basic networking tools such as `ifconfig`, `netstat`, `route`, `arp`
# nmap          - port scanning and other network reconnaissance
# traceroute    - self explanatory. alternative to `mtr`
# netcat        - `nc` tool. highly versatile TCP/UDP/unixsocket client and server
# iproute2      - provides the `ip` and `bridge` tools for advanced network configs
# tcpdump       - similar to wireshark, but CLI based. for inspecting network packets
# iputils-ping  - for the `ping` command. supports both IPv4 and v6 in the same binary, instead of `ping` + `ping6`
# openssh       - server and client. for testing ssh connectivity, and so you may ssh into the container for a better experience
# tmux          - run multiple things in one terminal session, with tabs and split windows
# screen        - similar to tmux, for running things in the background
# vim/nano      - for times when you need a text editor. remember! don't expect files on a container to be persisted. use a volume.

RUN apt-get update -y && \
    apt-get install -y bash-completion command-not-found mtr-tiny dnsutils net-tools && \
    apt-get install -y nmap traceroute netcat iproute2 tcpdump iputils-ping && \
    apt-get install -y openssh-server openssh-client tmux screen vim nano && \
    apt-get clean -qy

# More readable bash prompt, with timestamp and colours
# Plus set up SSH, with default root pass of 'net'
SHELL ["/bin/bash","-c"]
RUN echo 'PS1="\[\033[35m\]\t \[\033[32m\]\h\[\033[m\]:\[\033[33;1m\]\w\[\033[m\] # "' >> /root/.bashrc && \
    chsh -s /bin/bash root && \
    mkdir /run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo 'root:net' | chpasswd

# SSH Port
EXPOSE 22
# Alternative SSH port, not that it matters
EXPOSE 2222

# Ports 10000 to 20000 are exposed for general use in network debugging
# For example, listening on port 10100 with `nc` and connecting to it from
# outside of the container, to test connectivity

EXPOSE 10000-20000

CMD echo && echo Launching sshd - default port 22, root password is net && \
    /usr/sbin/sshd && \
    echo Container ready. IP for eth0 is $(ip addr show eth0 | awk '/inet/{print $2; exit}') && \
    echo If you want to connect using ssh: username root - password net && \
    echo ------------------------------------ && \
    echo For convenience, a bash shell will be launched. But to avoid accidentally killing the container, it\'s recommended not to use it. && \
    echo Instead, launch the container in the background with: docker run --name nettools -p 127.0.0.1:2222:22 -itd someguy123/net-tools && \
    echo Then connect via \'ssh root@127.0.0.1 -p 2222\', or use docker exec -it nettools bash && \
    echo ------------------------------------ && \
    echo Launching bash shell && \
    echo && bash



