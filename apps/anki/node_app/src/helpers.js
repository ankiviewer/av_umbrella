const getCollection = (db) => new Promise((resolve, reject) => {
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

  return f;
}

const getAllNotes = (db, collection) => new Promise((resolve, reject) => {
  db.all(
  `SELECT
  notes.id AS anki_note_id,
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
          anki_note_id: note.anki_note_id,
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

module.exports = { getCollection, getAllNotes, formatFlds }
