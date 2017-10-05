const tape = require('tape');
const assert = require('assert');
const dbSetup = require('./schema.js');
const {
  server,
  db,
  getAllModels,
  getAllNotes
} = require('../src/server.js');

const models = {
  1234: 'deen',
  1235: 'ende',
  1236: 'reverse'
}

const notes = [
  {type: 'deen', flds: 'gackernto cluck', sfld: 'to cluck'},
  {type: 'deen', flds: 'hallohello', sfld: 'hello'},
  {type: 'ende', flds: 'der Saltothe summersault', sfld: 'the summersault'}
];

tape('setup', (t) => dbSetup().then(t.end));

tape('getAllModels', (t) => {
  getAllModels()
    .then((actualModels) => {
      t.deepEqual(actualModels, models);
      t.end();
    });
});

tape('getAllNotes', (t) => {
  getAllNotes(models)
    .then((actualNotes) => {
      t.deepEqual(actualNotes, notes);
      t.end();
    })
});

tape('GET :: /', (t) => {
  server.inject('/')
    .then((res) => {
      t.equal(res.statusCode, 200);
      t.equal(res.payload, 'Hello World');
      t.end();
    });
});

tape('GET :: /notes', (t) => {
  server.inject('/notes')
    .then((res) => {
      t.equal(res.statusCode, 200);
      t.deepEqual(res.payload, JSON.stringify(notes));
      t.end();
    });
});

