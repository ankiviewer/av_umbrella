const { db } = require('../src/config.js');
const { models, decks, tags, cards, notes } = require('./models.js'); 

module.exports = () => new Promise((resolve) => {
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
      sfld text not null,
      tags text,
      mod integer not null
      )
    `);
    const noteStmt = db.prepare(`
      insert into notes (id, mid, flds, sfld, tags, mod)
      values (?, ?, ?, ?, ?, 0)
    `);
    notes.forEach((note) => {
      noteStmt.run([note.id, note.mid, note.flds, note.sfld, note.tags]);
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
        cards.forEach((card) => {
          cardStmt.run([card.nid, card.did]);
        });
        cardStmt.finalize(resolve);
      });
    });
  });
});

