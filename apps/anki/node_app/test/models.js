const { models, decks, tags, cards, formattedNotes } = require('./models.json');

const notes = formattedNotes.map((n) => ({
  mid: Object.keys(models)
    .map((k) => ({mid: k, name: models[k].name}))
    .filter((m) => m.name === n.model)[0].mid,
  flds: n.one + '\u001f' + n.two,
  sfld: n.two,
  tags: n.tags,
  mod: n.mod,
  id: n.anki_note_id,
  deck: n.deck
}));

module.exports = { models, decks, tags, cards, notes, formattedNotes };
