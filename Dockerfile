FROM node:0.10.30

RUN apt-get -y update
RUN apt-get -y install procps

RUN curl https://install.meteor.com/ | sh
RUN npm install -g meteorite

RUN apt-get -y install coffeescript

RUN mkdir -p /home/app/node_modules && cd /home/app/node_modules && npm install libxmljs exec-sync path && cd .. && mrt create src && cd src && rm src.*

ADD src/ /home/app/src/

RUN cd /home/app/src && mrt add coffeescript

WORKDIR /home/app

ADD Makefile /home/app/

CMD make

ENV ROOT_URL http://127.0.0.1
ENV PORT 3000

EXPOSE 3000