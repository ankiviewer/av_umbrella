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
].map((c, i) => Object.assign(c, {nid: i + 1}));

const notes = [
  {mid: 1234, flds: 'gackernto cluck', sfld: 'to cluck'},
  {mid: 1234, flds: 'hallohello', sfld: 'hello'},
  {mid: 1235, flds: 'der Saltothe summersault', sfld: 'the summersault'},
  {mid: 7654, flds: 'Chaiyes', sfld: 'yes'}
].map((n, i) => Object.assign(n, {id: i + 1}));

const formattedNotes = [
  // {type: 'deen', english: 'to cluck', german: 'gackern', tags: 'verb verified'},
  {type: 'deen', flds: 'gackernto cluck', sfld: 'to cluck'},
  {type: 'deen', flds: 'hallohello', sfld: 'hello'},
  {type: 'ende', flds: 'der Saltothe summersault', sfld: 'the summersault'},
  {type: 'thaidefault', flds: 'Chaiyes', sfld: 'yes'}
]

module.exports = { models, decks, tags, cards, notes, formattedNotes };
