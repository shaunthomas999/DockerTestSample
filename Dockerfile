###
#
# Dockerfile for phusion/passenger-customizable
# Author : Shaun Thomas
# Date : 21 Aug 2014
#
###

# Base image
# Info - https://registry.hub.docker.com/u/phusion/passenger-customizable/
FROM phusion/passenger-customizable:0.9.11

# Set correct environment variables.
ENV HOME /root

# Update apt cache
RUN apt-get update

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

## Features to install
# Build system and git.
RUN /build/utilities.sh

# Python support.
#IMP# Error for below script
RUN /build/python.sh
#RUN apt-get -y install python

# Node.js and Meteor support.
RUN /build/nodejs.sh

# Enable Nginx and Passenger
RUN rm -f /etc/service/nginx/down

# Install the insecure key permanently - Only for temporary development or demo environments
#IMP# Delete below line for production
RUN /usr/sbin/enable_insecure_key

# Deploy the Nginx configuration file for webapp
ADD webapp.conf /etc/nginx/sites-enabled/webapp.conf

# <App> specific instructions
RUN cd /tmp && npm install libxmljs exec-sync path
RUN mkdir -p /home/app/webapp && cp -a /tmp/node_modules /home/app/webapp/

WORKDIR /home/app/webapp

ADD src/ /home/app/webapp/src/

WORKDIR src

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*