# KalliopeDocker
A docker file to have Kalliope build &amp; run in a Ubuntu 18.04 based container

By default, kalliope directly uses alsa for audio capture & playback, so the container has
the pulseaudio alsa plugin, in order to use the host pulse server without conflicting.

# Build
docker run -ti --read-only --network=host --tmpfs /tmp  --user=$(id -u):$(id -g) kalliope 

# Run
docker run -it  --network=host --tmpfs /tmp   --security-opt=seccomp:unconfined --user=$(id -u):$(id -g)  -v $HOME/Alexa/workdir:/workdir  --rm  --volume=/run/user/$(id -u)/pulse:/run/user/1000/pulse -e PULSER_SERVER=unix:/run/user/1000/pulse/native   kalliope
