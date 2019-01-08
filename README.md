# Docker Networking Toolkit 

#### Originally created by @someguy123 ([Github](https://github.com/Someguy123) | [Steemit](https://steemit.com/@someguy123))

##### Licensed under the MIT license (See LICENSE)

**Docker Hub:** [someguy123/net-tools](https://hub.docker.com/r/someguy123/net-tools)

This is a docker image which builds Ubuntu 18.04 LTS with various networking tools pre-installed, for debugging networks.

It was created as Ubuntu's docker image contains absolutely no networking tools, not even the most basic `ifconfig`, `route`, or `ip`. This makes it practically useless for basic networking tasks. 

Originally developed for [GNS3 (network prototyping tool)](https://www.gns3.com), this container is perfect for troubleshooting and testing your GNS3 topology using the built-in Docker support. No need to set up bloated Linux VMs, just type into the image selection box `someguy123/net-tools` and you're ready to debug your network.

As this image is likely to be used directly from it's console, `bash-completion` and `command-not-found` are both included, plus a colorised bash prompt with timestamps.

Basic utilities such as `tmux`, `screen`, `vim` and `nano` are also included, making this image feel more like a normal VM, rather than a barebones docker container.

# Quickstart

A pre-built binary image is available on Docker Hub.

```
docker pull someguy123/net-tools
docker run --name nettools -p 127.0.0.1:2222:22 -itd someguy123/net-tools
# password: net
ssh root@127.0.0.1 -p 2222
```

More detailed information on how to use this image, including how to use it in [GNS3 (network prototyping tool)](https://www.gns3.com) is available further down.

# What's included

- **bash-completion**   - to make bash tab completion better
- **command-not-found** - when you type a command that doesn't exist, it informs you of which package a command is in
- **mtr-tiny**      - fast and easy to read realtime traceroutes for both IPv4 and IPv6 (tiny version skips all the GTK bloat)
- **dnsutils**      - provides tools such as `dig` and `nslookup` for DNS debugging
- **net-tools**     - basic networking tools such as `ifconfig`, `netstat`, `route`, `arp`
- **nmap**          - port scanning and other network reconnaissance
- **traceroute**    - self explanatory. alternative to `mtr`
- **netcat**        - `nc` tool. highly versatile TCP/UDP/unixsocket client and server
- **iproute2**      - provides the `ip` and `bridge` tools for advanced network configs
- **tcpdump**       - similar to wireshark, but CLI based. for inspecting network packets
- **iputils-ping**  - for the `ping` command. supports both IPv4 and v6 in the same binary, instead of `ping` + `ping6`
- **openssh**       - server and client. for testing ssh connectivity, and so you may ssh into the container for a better experience
- **tmux**          - run multiple things in one terminal session, with tabs and split windows
- **screen**        - similar to tmux, for running things in the background
- **vim/nano**      - for times when you need a text editor. remember! don't expect files on a container to be persisted. use a volume.

# Usage

### Standard Docker

Pull the image from Docker hub

```
docker pull someguy123/net-tools
```

Launch the docker image, with the SSH port forwarded. SSH will offer a better terminal experience than docker's TTY

**NOTE: Please be careful with your docker port forwards. The SSH password is only 3 characters (`net`), there is no firewall inside of the container, and there is no rate limiting such as fail2ban.**

**Your container could be compromised if the SSH port is exposed to the internet carelessly.**

```
docker run --name nettools -p 127.0.0.1:2222:22 -itd someguy123/net-tools
```

Now you can SSH into the container, use the username `root` and the password `net`

```
ssh root@127.0.0.1 -p 2222

root@127.0.0.1's password:
Welcome to Ubuntu 18.04.1 LTS

04:05:59 32b9bd38c2f9:~ # ping 8.8.4.4
PING 8.8.4.4 (8.8.4.4) 56(84) bytes of data.
64 bytes from 8.8.4.4: icmp_seq=1 ttl=37 time=16.8 ms
64 bytes from 8.8.4.4: icmp_seq=2 ttl=37 time=16.3 ms
```

Alternatively you can use the container without logging into SSH, just remove `-p 127.0.0.1:2222:22`, and use docker to launch a shell:

```
docker exec -it nettools bash
```


### For GNS3

Open the settings, go to Docker>Docker Containers, click the "New" button, select whether you're using a local or remote GNS3 server, and then it will ask you for a docker image. Click "New Image" and enter `someguy123/net-tools`.

![Screenshot of GNS3 Docker wizard](https://i.imgur.com/0wRbBJq.png)

It will ask you to name it, and select how many adapters you would like. Fill those out as you want.

When it asks for a "start command", simply leave the box blank. By default the container starts a bash shell, so that it's usable out of the box via the **console** menu option in your topology.

Leave the **console type** as telnet. You can also leave the environment options blank.

You should now have an appliance called **someguy123-net-tools** (or whatever you changed the name to).

![Screenshot of GNS3 main window](https://i.imgur.com/t48rOgz.png)

In your GNS3 project, you'll find the docker image under "End Devices" (the monitor icon). Simply drag it into your topology, and connect it as you would any other device.

![](https://i.imgur.com/v19JAYx.png)

After placing it on the topology, connecting it to your network, and then pushing "Start", you'll be able to access the console just like other devices in GNS3. You also have easy access to `/etc/network/interfaces` just by clicking the **Configure** menu item.

For a better experience, you should be able to connect via SSH to any configured IP addresses. Configure the networking through the **Configure** menu (will restart the container), or using standard Linux network tools (`ip`, `ifconfig` and `route` are all available). Be warned that persistence is not guaranteed with docker, files such as configurations may get wiped out when the container is shutdown in GNS3.

### Manual Build

If you need to customise the image, you can build it manually:

```
git clone https://github.com/someguy123/docker-networktools
cd docker-networktools
docker build . -t nettools
```

You can then use the image `nettools` with `docker run -itd nettools` as previously shown.

# Has this project helped you?

I accept donations via **Bitcoin**, **Litecoin** and **Steem**:

**Steem:** [@someguy123](https://steemit.com/@someguy123)

**LTC:** `LYmpJZm1WrP5FSnxwkV2TTo5SkAF4Eha31`

**BTC:** `39u6LHw8nY8ZB6daSxpdavoHi6cnoe78B1`


