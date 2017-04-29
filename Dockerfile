FROM ubuntu:16.04

LABEL maintainer "Matt Bruzek <mbruzek@gmail.com>"

# Architectures can be: https://golang.org/doc/install/source#environment
ARG GO_ARCH=amd64
# OS values can be: https://golang.org/doc/install/source#environment
ARG GO_OS=linux
# The version of golang you would like to install.
ARG GO_VERSION=1.8.1

# Build the filename from the version, OS, and architecture.
ENV GO_FILENAME="go${GO_VERSION}.${GO_OS}-${GO_ARCH}.tar.gz"
# Build the URL for the golang binary to download and install.
ENV GO_BINARY_URL="https://golang.org/dl/${GO_FILENAME}"
# Build the URL that contains thesha256sum of the golang binary.
ENV GO_SHA256_URL="https://storage.googleapis.com/golang/${GO_FILENAME}.sha256"

RUN apt-get update -qq
RUN apt-get install -y --no-install-recommends \
    ca-cacert \
    curl \
    g++ \
    gcc \
    libc6-dev \
    make \
    pkg-config \
    wget

# Download the golang binary, rename it to something simple.
RUN set -eux; url="$GO_BINARY_URL"; wget -nv -O go.tgz $url
# Download the sha256sum and check it against the renamed file.
RUN set -eux; echo "`curl -sS $GO_SHA256_URL` go.tgz" | sha256sum -c -
# Extract the archive to the /usr/local directory.
RUN tar -C /usr/local -xzf go.tgz
RUN rm -f go.tgz

ENV GOPATH /go
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin"
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

VOLUME $GOPATH/src

WORKDIR $GOPATH

RUN apt-get autoremove -qy
RUN apt-get autoclean -qy

RUN echo "`go version`"
