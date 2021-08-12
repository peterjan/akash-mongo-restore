FROM debian:buster

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && apt-get install -y gnupg wget
RUN wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -
RUN echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/5.0 main" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list
RUN apt-get update && apt-get install -y curl cron netcat nodejs npm mongodb-org

RUN node -v
RUN npm install -g skylinkv2-cli

COPY ./scripts /scripts
RUN chmod +x /scripts/*.sh

ENV MONGODB_HOST=mongo
ENV MONGODB_PORT=27017
ENV MONGODB_USER=root

ENV BACKUP_SCHEDULE="*/15 * * * *"

COPY ./crontab /crontab

CMD /scripts/run.sh
