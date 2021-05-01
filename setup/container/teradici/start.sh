#!/bin/bash
xhost +local:docker
sudo systemctl enable docker
sudo systemctl start docker
docker run -d -h myhost --network host -v /home/bensch/docker/teradici/.config/:/home/bensch/.config/Teradici -v /home/bensch/docker/teradici/.logs:/tmp/Teradici/bensch/PCoIPClient/logs -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=:0 pcoip-client
