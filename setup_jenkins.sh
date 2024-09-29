#!/bin/bash

echo "Starting Jenkins with Docker..."

docker run -d \
  --name jenkins \
  -p 8081:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts

echo "Jenkins is running on http://localhost:8081"

