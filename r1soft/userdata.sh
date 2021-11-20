#!/bin/bash
sudo yum install wget -y
sudo wget https://tim-repo-bucket.s3.amazonaws.com/r1soft.repo -P /etc/yum.repos.d/

yum install serverbackup-enterprise -y 
sudo serverbackup-setup --user admin --pass r1soft
sudo /etc/init.d/cdp-server restart
sudo serverbackup-setup --http-port 8080 --https-port 443
sudo /etc/init.d/cdp-server restart