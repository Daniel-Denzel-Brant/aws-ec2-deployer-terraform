#! /bin/bash
sudo yum update -y

#Docker
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo docker pull danieldbrant/node-server:node-1.0
docker run -d -p 3000:3000 danieldbrant/node-server:node-1.0