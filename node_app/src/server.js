const { db, server } = require('./config.js')

/**
 * returns a promise containing a formatted array of all models
 * @promise {Object{modelId: modelName}}
 */
const getAllModels = () => new Promise((resolve, reject) => {
  // db.get('select models, decks, tags, mod from col', (err, {models: _models}) => {
  db.get('select models from col', (err, {models: _models}) => {
    if (err) {
      reject(err);
      return;
    }
    const models = JSON.parse(_models);
    resolve(Object.keys(models)
      .reduce((prev, curr) => {
        prev[curr] = models[curr].name;
        return prev;
      }, {})
    );
  });
});

/**
 * returns a promise containing all data on all notes
 * @params {Object{modelId: modelName}}
 * @promise {Array.Object{}}
 */
const getAllNotes = (models) => new Promise((resolve, reject) => {
  // db.all(
  // `SELECT
  // notes.mid AS model,
  // notes.mod AS modied,
  // notes.tags AS tags,
  // notes.flds AS flds,
  // notes.sfld AS sfld,
  // cards.did AS deckid
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
          type: models[note.mid],
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
      getAllModels()
        .then(getAllNotes)
        .then(reply)
        .catch((err) => {
          console.log('ERR: ', err);
        });
    }
  }
]

server.route(routes);

module.exports = { server, db, getAllModels, getAllNotes }
