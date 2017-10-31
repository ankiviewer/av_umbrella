const { db } = require('../src/server.js');

const models = {
  1234: {name: 'deen'},
  1235: {name: 'ende'},
  1236: {name: 'reverse'}
};

const decks = {
  1: {name: 'Default'},
  123456: {name: 'DE'},
  654321: {name: 'Thai'}
};

const tags = {
  sentence: 0,
  marked: 0,
  duplicate: 0,
  verb: 0,
  'to-restructure': 0,
  'verified-by-vanessa': 0,
  leech: 0
}

const notes = [
  {mid: 1234, flds: 'gackernto cluck', sfld: 'to cluck'},
  {mid: 1234, flds: 'hallohello', sfld: 'hello'},
  {mid: 1235, flds: 'der Saltothe summersault', sfld: 'the summersault'}
];

const dbSetup = module.exports = () => new Promise((resolve) => {
  db.serialize(() => {
    // MODELS
    db.run('drop table if exists col');
    db.run(`
      create table col (
        models text not null,
        decks text not null,
        tags text not null,
        mod integer not null
      )
    `);
    db.run(
      'insert into col (models, decks, tags, mod) values (?, ?, ?, 0)',
      [models, decks, tags].map(JSON.stringify)
    );

    // NOTES
    db.run('drop table if exists notes');
    db.run(`
      create table notes (
      mid integer not null,
      flds text not null,
      sfld text not null
      )
    `);
    const stmt = db.prepare(`
      insert into notes (mid, flds, sfld)
      values (?, ?, ?)
    `);
    notes.forEach((note) => {
      stmt.run([note.mid, note.flds, note.sfld]);
    });
    stmt.finalize(resolve);
  });
});

