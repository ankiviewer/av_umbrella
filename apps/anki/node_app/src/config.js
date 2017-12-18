const Hapi = require('hapi');
const routes = require('./roots.js');
const port = process.env.PORT || 5555;
const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const server = new Hapi.Server();
server.connection({ port });

const db = (process.env.NODE_ENV || '').toUpperCase() === 'TEST'
  ? new sqlite3.Database(':memory:')
  : new sqlite3.Database(
    path.join(
      process.env.HOME,
      'Library',
      'Application\ Support',
      'Anki2',
      'sam',
      'collection.anki2'
    ),
    sqlite3.READ_ONLY
  );

server.route(routes(db));

module.exports = { db, server };
