const Hapi = require('hapi');
const assert = require('assert');
const port = process.env.PORT || 4444;
const server = new Hapi.Server();
const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const db = new sqlite3.Database(
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

server.connection({ port });

const _query = (method) => (query) => new Promise((resolve, reject) => {
  db[method](query, (err, res) => {
    if (err) {
      reject(err);
      return
    }
    resolve(res);
  });
});

const query = { get: _query('get'), all: _query('all') }

const getAllResults = () => new Promise((resolve, reject) => {
  return query.get('select models from col')
    .then(({models: _models}) => {
      const models = JSON.parse(_models);
      const formattedModels = Object.keys(models)
        .reduce((prev, curr) => {
          prev[curr] = models[curr].name;
          return prev;
        }, {});
      query.all('select mid, flds, sfld from notes')
        .then((notes) => {
          resolve(
            notes.map((note) => {
              return {
                type: formattedModels[note.mid],
                flds: note.flds
                  .split('\u001f')
                  .filter((str) => {
                    return [note.sfld, ''].indexOf(str) === -1
                  })[0],
                sfld: note.sfld
              };
            })
          );
        })
        .catch(reject);
    })
});

const routes = [
  {
    method: 'get',
    path: '/notes',
    handler: (request, reply) => {
      getAllResults()
        .then(reply)
        .catch((err) => {
          console.log('ERR: ', err);
        });
    }
  }
]

server.route(routes);

module.exports = server;
