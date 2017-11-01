const { db, server } = require('./config.js')

const getCollection = () => new Promise((resolve, reject) => {
  db.get('select models, decks, tags, mod from col', (err, {models, decks, tags, mod}) => {
    if (err) {
      reject(err);
      return;
    }
    resolve({
      models: JSON.parse(models),
      decks: JSON.parse(decks),
      tags: JSON.parse(tags),
      mod
    });
  });
});

const getAllNotes = (collection) => new Promise((resolve, reject) => {
  // db.all(
  // `SELECT
  // notes.mid AS mid,
  // notes.mod AS mod,
  // notes.tags AS tags,
  // notes.flds AS flds,
  // notes.sfld AS sfld,
  // cards.did AS did
  // FROM
  // notes
  // INNER JOIN cards
  // ON
  // notes.id = cards.nid`
  // , (err, notes) => {
  db.all('select mid, flds, sfld from notes', (err, notes) => {
    if (err) {
      reject(err);
      return;
    }
    resolve(
      notes.map((note) => {
        return {
          type: collection.models[note.mid].name,
          flds: note.flds
            .split('\u001f')
            .filter((str) => {
              return [note.sfld, ''].indexOf(str) === -1
            })[0],
          sfld: note.sfld
        };
      })
    );
  });
});

const routes = [
  {
    method: 'get',
    path: '/',
    handler: (_request, reply) => reply('Hello World')
  },
  {
    method: 'get',
    path: '/notes',
    handler: (request, reply) => {
      getCollection()
        .then(getAllNotes)
        .then(reply)
        .catch((err) => {
          console.log('ERR: ', err);
        });
    }
  }
]

server.route(routes);

module.exports = { server, db, getCollection, getAllNotes }
