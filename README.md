# Go development environment

Go (golang) is a programming language. This container that provides a go
development environment.

This project is a Docker container provides the basic tools you need to get
started using the go programming language.

The two main use cases are to compile a go application, or to use go tools
without installing go on your system.

# Usage

To build a container with the defaults:   
```
docker build -t go-dev .
```

To build a container with a specific version of go use the major.minor.patch
semver notation:  
```
docker build -t go-dev:1.6.1 . --build-arg GO_VERSION=1.6.1
```

The `docker build` process downloads and installs the specified golang binary
and verifies the sha256sum of that binary.

Once the container is build you can use it to compile go applications, or use
the go tools without installing go on your system.

# Using the Docker container for development

You can use the docker container for isolation to contain the golang tools
in the container rather than on your host system. The container can be
built with any valid semver golang version using the `--build-arg` flag.

```
docker run --rm -it -v "$PWD":/go/src/myapp -w /go/src/myapp go-dev:1.8.1
```
This command will add the current working directory as a volume and set the
working directory to the volume and run the container in interactive mode. Any
changes to files in the volume directory will persist after the container is
stopped.

# To compile golang applications inside the Docker container

To compile the golang application run something like this:  

```
docker run --rm -v "$PWD":/go/src/myapp -w /go/src/myapp go-dev:1.8.1 go build -v
```
This command will add the current working directory as a volume to the
container, set the working directory to the volume, and run the command
`go build` inside the container, which will compile the project in the
working directory and output the executable.

If you are using a `Makefile` in your project you can run the `make`
command inside the container.

```
docker run --rm -v "$PWD":/go/src/myapp -w /go/src/myapp go-dev:1.8.1 bash -c make
```
This command will run the `make` command in a bash shell.
