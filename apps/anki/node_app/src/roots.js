const { getCollection, getAllNotes } = require('./helpers.js');

/* istanbul ignore next */
const handleErr = (err) => console.log('ERR: ', err); // eslint-disable-line

const routes = (db) => [
  {
    method: 'get',
    path: '/',
    handler: (request, reply) => reply('hello world')
  },
  {
    method: 'get',
    path: '/collection',
    handler: (_request, reply) => {
      getCollection(db)
        .then(reply)
        .catch(handleErr);
    }
  },
  {
    method: 'get',
    path: '/notes',
    handler: (_request, reply) => {
      getCollection(db)
        .then((col) => getAllNotes(db, col))
        .then(reply)
        .catch(handleErr);
    }
  }
]

module.exports = routes;
