const tape = require('tape');
const dbSetup = require('./setup.js');
const { models, decks, tags, formattedNotes } = require('./models.js');
const { getCollection, getAllNotes, formatFlds } = require('../src/helpers.js');
const { server, db } = require('../src/config.js');

const collection = { models, decks, tags, mod: 0 };

tape('setup', (t) => dbSetup(db).then(t.end));

tape('getCollection', (t) => {
  getCollection(db)
    .then((actualCollection) => {
      t.deepEqual(actualCollection, collection);
      t.end();
    });
});

tape('getAllNotes', (t) => {
  getAllNotes(db, collection)
    .then((actualNotes) => {
      t.deepEqual(actualNotes, formattedNotes);
      t.end();
    })
});

tape('GET :: /collection', (t) => {
  server.inject('/collection')
    .then((res) => {
      t.equal(res.statusCode, 200);
      t.deepEqual(JSON.parse(res.payload), collection);
      t.end();
    });
});

tape('GET :: /notes', (t) => {
  server.inject('/notes')
    .then((res) => {
      t.equal(res.statusCode, 200);
      t.deepEqual(JSON.parse(res.payload), formattedNotes);
      t.end();
    });
});

tape('formatFlds', (t) => {
  const flds = 'plaudern\u001fto chat';
  const sfld = 'to chat';

  const actual = formatFlds(flds, sfld);
  const expected = 'plaudern';

  t.equal(actual, expected);
  t.end();
});

