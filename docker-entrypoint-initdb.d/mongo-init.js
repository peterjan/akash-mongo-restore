print('Start ################################################################');

db = db.getSiblingDB('akash_mongo');
db.createUser(
  {
    user: 'akash_user',
    pwd: 'test123',
    roles: [{ role: 'readWrite', db: 'akash_mongo' }],
  },
);
db.createCollection('records');

print('END ##################################################################');