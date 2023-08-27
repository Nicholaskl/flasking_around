# Flasking Around Project

This is the readme file for a random Flask app I want to learn how to make. It uses a docker container to spin up a flask application so I don't have to muck around and do that haha.

## Building and running the docker container

First we have to build the docker container and give it a name:
```zsh
docker build -t test:latest .
```

And then we'll need to run it:
```zsh
docker run -p 127.0.0.1:8000:8000 test:latest
```