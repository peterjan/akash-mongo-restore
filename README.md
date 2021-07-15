# Akash MongoDB Restore

An auto-restoring MongoDB server running on Akash, with backups taken on a
configurable schedule. Backups are stored on Skynet, which is a decentralised
cloud storage technology.

Ultimately this is a two container setup, one MongoDB server and one scheduler
container to restore the database on boot, and run a cronjob to back it up. 

## Usage

- Set up the desired environment variables in the `.env` file.
- Set the environment variables in the [deploy.yml](deploy.yml) and deploy on Akash

The database will be stored on Skynet, under a Skylink that is decided by the
`SKYNET_SEED` and `SKYNET_DATAKEY`. Using the same values for those environment
variables will allow you to restore your database. Note that the database will
also get encrypted using the provided `SKYNET_SEED`

### Using with an app container

Alternatively add your own app container to the deploy.yml and expose Mongo's
standard 27017 port to your application only for a local server.

For example:

```
services:
  app: 
    image: myappimage:v1
    depends_on: 
      - service: mongodb
  cron:
    image: ghcr.io/ovrclk/akash-postgres-restore:v0.0.4
    env:
      - MONGODB_USERNAME=root
      - MONGODB_PASSWORD=password
      - MONGODB_DATABASE=akash_mongo
      - SKYNET_SEED=mysecret
      - SKYNET_DATAKEY=mongobackup
    depends_on:
      - service: mongodb
  mongodb:
    image: mongo
    container_name: mongodb
    ports:
      - "27017:27017"
    volumes:
      - ./docker-entrypoint-initdb.d/mongo-init.js:/docker-entrypoint-initdb.d/mongo-init.js:ro
    environment:
      MONGO_INITDB_DATABASE: root-db
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: password
    expose:
      - port: 27017
        to:
          - global: true
          - service: cron

```

### Environment variables

- `MONGODB_USERNAME=root` - your MongoDB username
- `MONGODB_PASSWORD=password` - your MongoDB password
- `MONGODB_DATABASE=akash_mongo` - your MongoDB database name

- `SKYNET_SEED=mysecret` - a passphrase to encrypt your backups with
- `SKYNET_DATAKEY=secret` - a datakey that decides where the backup gets stored

- `BACKUP_SCHEDULE=*/15 * * * *` - the cron schedule for backups


## Development

You can run the application locally using Docker compose. 

Copy the `.env.sample` file to `.env` and populate 

Run `docker-compose up` to build and run the application

