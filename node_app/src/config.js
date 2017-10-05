const Hapi = require('hapi');
const port = process.env.PORT || 4444;
const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const server = new Hapi.Server();
server.connection({ port });

const db = process.env.NODE_ENV === 'TEST'
  ? new sqlite3.Database(':memory:')
  : new sqlite3.Database(
    path.join(
      process.env.HOME,
      'Library',
      'Application\ Support',
      'Anki2',
      'User\ 1',
      'collection.anki2'
    ),
    sqlite3.READ_ONLY
  );

const config = { db, server }

module.exports = config;
