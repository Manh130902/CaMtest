#!/bin/bash
docker rm -f python-server
docker rmi -f python-server
docker build -t python-server .
docker run -d --network host --name python-server python-server
