const models = {
  1234: {name: 'deen'},
  1235: {name: 'ende'},
  1236: {name: 'reverse'},
  7654: {name: 'thaidefault'}
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

const cards = [
  {did: 123456},
  {did: 123456},
  {did: 123456},
  {did: 654321}
].map((c, i) => Object.assign(c, {nid: i + 1, mod: 0}));

const formattedNotes = [
  {model: 'deen', one: 'gackern', two: 'to cluck', tags: 'leech verb', deck: 'DE'},
  {model: 'deen', one: 'hallo', two: 'hello', deck: 'DE'},
  {model: 'ende', one: 'der Salto', two: 'the summersault', tags: 'leech', deck: 'DE'},
  {model: 'thaidefault', one: 'Chai', two: 'yes', deck: 'Thai'}
].map((n) => Object.assign(n, {mod: 0, tags: n.tags || ''}));

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
