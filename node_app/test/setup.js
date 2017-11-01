const { db } = require('../src/server.js');
const { models, decks, tags, cards, notes } = require('./models.js'); 

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
      id integer not null,
      mid integer not null,
      flds text not null,
      sfld text not null
      )
    `);
    const noteStmt = db.prepare(`
      insert into notes (id, mid, flds, sfld)
      values (?, ?, ?, ?)
    `);
    notes.forEach((note) => {
      noteStmt.run([note.id, note.mid, note.flds, note.sfld]);
    });
    noteStmt.finalize(() => {
      db.serialize(() => {
        // CARDS
        db.run('drop table if exists cards');
        db.run(`
          create table cards (
          nid integer not null,
          did integer not null
          )
        `);
        const cardStmt = db.prepare(`
          insert into cards (nid, did)
          values (?, ?)
        `);
        cards.forEach((card, i) => {
          cardStmt.run([card.nid, card.did]);
        });
        cardStmt.finalize(resolve);
      });
    });
  });
});

