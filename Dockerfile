FROM ubuntu:18.04

RUN apt update
RUN apt -y upgrade

RUN apt install -y git
RUN apt install -y python-dev
RUN apt install -y libsmpeg0
RUN apt install -y libttspico-utils
RUN apt install -y libsmpeg0
RUN apt install -y flac
RUN apt install -y dialog
RUN apt install -y libffi-dev
RUN apt install -y libssl-dev
RUN apt install -y portaudio19-dev
RUN apt install -y build-essential 
RUN apt install -y libssl-dev
RUN apt install -y sox 
RUN apt install -y libatlas3-base
RUN apt install -y mplayer
RUN apt install -y sudo
RUN apt install -y alsa-utils
RUN apt install -y pulseaudio-utils
RUN apt install -y libasound2-plugins
RUN apt install -y python-pip
RUN apt install -y strace
RUN apt install -y vim
RUN apt install -y locales

ARG lang=fr_FR

# Locale settings

RUN echo "set locales..., activate ${lang}"

RUN cat /etc/locale.gen | grep ${lang}

RUN sh -c "lang=${lang}; sed -i -e '/${lang}/s/^#*\s*//g' /etc/locale.gen"
RUN cat /etc/locale.gen | grep ${lang}
RUN echo 'LANG="${lang}.UTF-8"'>/etc/default/locale
RUN dpkg-reconfigure --frontend=noninteractive locales
RUN update-locale LANG=${lang}.UTF-8

# User setting

ARG gid=1000
RUN groupadd -g $gid user
ARG uid=1000
RUN useradd -u $uid -g user user
RUN mkdir /workdir && chown user /workdir
RUN mkdir -p /home/user && chown -R user:user /home/user

RUN echo "user ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

COPY pulse-client.conf /etc/pulse/client.conf
COPY asound-pulse.conf /etc/asound-pulse.conf
COPY alsa-pulse.conf   /etc/alsa-pulse.conf

ENV ALSA_CONFIG_PATH=/etc/alsa-pulse.conf
ENV sudo='sudo -h localhost'

USER user
WORKDIR /home/user



RUN git clone https://github.com/iotbzh/kalliope.git
#RUN git clone git@github.com:iotbzh/kalliope.git

RUN cd kalliope && $sudo python setup.py install

# This one does not have read permissions for user !
RUN $sudo chmod a+r /usr/local/lib/python2.7/dist-packages/httpretty-0.9.6-py2.7.egg/EGG-INFO/requires.txt

ENTRYPOINT [ "/bin/bash" ]


