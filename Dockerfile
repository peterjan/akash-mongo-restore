FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && apt-get install -y curl cron netcat nodejs npm mongodb

RUN node -v
RUN npm install -g skylinkv2-cli

COPY ./scripts /scripts
RUN chmod +x /scripts/*.sh

ENV MONGODB_HOST=mongo
ENV MONGODB_PORT=27017
ENV MONGODB_USER=root

ENV BACKUP_SCHEDULE="* * * * *"

COPY ./crontab /crontab

CMD /scripts/run.sh
