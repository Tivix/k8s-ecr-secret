FROM python:3.7.7-slim-buster

LABEL maintainer="michal.kopacki@tivix.com"

ENV kubectl_version=v1.17.0
ENV kubectl_checksum=6e0aaaffe5507a44ec6b1b8a0fb585285813b78cc045f8804e70a6aac9d1cb4c

ADD https://storage.googleapis.com/kubernetes-release/release/${kubectl_version}/bin/linux/amd64/kubectl /tmp
ADD https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip /tmp
ADD parse-kube-config.sh /usr/local/bin/
ADD ecr-secret.sh /

RUN apt update &&\
	apt install unzip

WORKDIR /tmp

RUN sha256sum kubectl | grep -q ${kubectl_checksum} &&\
    chmod +x kubectl &&\
    mv /tmp/kubectl /usr/local/bin/ &&\
	unzip /tmp/awscli-exe-linux-x86_64.zip &&\
	./aws/install

WORKDIR /

RUN chmod +x ecr-secret.sh /usr/local/bin/parse-kube-config.sh &&\
    rm -rf /tmp/*

ENTRYPOINT /ecr-secret.sh