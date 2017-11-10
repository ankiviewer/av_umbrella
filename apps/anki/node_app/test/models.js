const { models, decks, tags, cards, formattedNotes } = require('./models.json');

const notes = formattedNotes.map((n, i) => ({
  mid: Object.keys(models)
    .map((k) => ({mid: k, name: models[k].name}))
    .filter((m) => m.name === n.model)[0].mid,
  flds: n.one + n.two,
  sfld: n.two,
  tags: n.tags,
  mod: n.mod,
  id: i + 1,
  deck: n.deck
}));

module.exports = { models, decks, tags, cards, notes, formattedNotes };
