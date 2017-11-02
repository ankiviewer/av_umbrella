const { db, server } = require('./config.js')

const getCollection = () => new Promise((resolve, reject) => {
  db.get(
    'select models, decks, tags, mod from col',
    (err, {models, decks, tags, mod}) => {
      /* istanbul ignore if */
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
    }
  );
});

const formatFlds = (flds, sfld) => {
  const f = flds
    .split('\u001f')
    .filter((str) => {
      return [sfld, ''].indexOf(str) === -1
    })[0];
  return f.substring(0, f.lastIndexOf(sfld));
}

const getAllNotes = (collection) => new Promise((resolve, reject) => {
  db.all(
  `SELECT
  notes.mid AS mid,
  notes.tags AS tags,
  notes.flds AS flds,
  notes.sfld AS sfld,
  cards.did AS did,
  notes.mod AS mod
  FROM
  notes
  INNER JOIN cards
  ON
  notes.id = cards.nid`,
  (err, notes) => {
    /* istanbul ignore if */
    if (err) {
      reject(err);
      return;
    }
    resolve(
      notes.map((note) => {
        return {
          model: collection.models[note.mid].name,
          one: formatFlds(note.flds, note.sfld),
          two: note.sfld,
          tags: note.tags,
          mod: note.mod,
          deck: collection.decks[note.did].name
        };
      })
    );
  });
});

/* istanbul ignore next */
const handleErr = (err) => console.log('ERR: ', err); // eslint-disable-line

const routes = [
  {
    method: 'get',
    path: '/collection',
    handler: (_request, reply) => {
      getCollection()
        .then(reply)
        .catch(handleErr);
    }
  },
  {
    method: 'get',
    path: '/notes',
    handler: (_request, reply) => {
      getCollection()
        .then(getAllNotes)
        .then(reply)
        .catch(handleErr);
    }
  }
]

server.route(routes);

module.exports = { server, db, getCollection, getAllNotes }
