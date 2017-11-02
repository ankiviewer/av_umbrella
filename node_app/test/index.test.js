const tape = require('tape');
const dbSetup = require('./setup.js');
const { models, decks, tags, formattedNotes } = require('./models.js');
const { server, getCollection, getAllNotes } = require('../src/server.js');

const collection = { models, decks, tags, mod: 0 };

tape('setup', (t) => dbSetup().then(t.end));

tape('getCollection', (t) => {
  getCollection()
    .then((actualCollection) => {
      t.deepEqual(actualCollection, collection);
      t.end();
    });
});

tape('getAllNotes', (t) => {
  getAllNotes(collection)
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

