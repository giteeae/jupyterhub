FROM alpine:latest AS juplabpine

LABEL version="1.0"
LABEL description="Jupyterhub + Jupyterlab for EEAE on alpine"

ENV HOME /root

WORKDIR /root

 RUN \
   apk update && \
   apk upgrade && \
   apk add python3 py3-pip vim nodejs npm jq moreutils gcc libc-dev python3-dev g++ linux-headers linux-pam openjdk17-jdk zip && \
   python3 -m pip install jupyterhub jupyterlab notebook jupyterlab-language-pack-es-ES && \
   npm install -g configurable-http-proxy && \
   jupyterhub --generate-config && \
   cat /usr/share/jupyter/kernels/python3/kernel.json | jq '.display_name = "Python 3"' | sponge /usr/share/jupyter/kernels/python3/kernel.json && \
   mkdir instalar && \
   cd instalar && \
   wget https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip && \
   unzip ijava-1.3.0.zip && \
   python3 install.py && \
   cd .. && \
   rm -rf instalar && \ 
   pass=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '') && \
   adduser admin; echo "admin:${pass}" | chpasswd 

ENTRYPOINT ["jupyterhub"]
