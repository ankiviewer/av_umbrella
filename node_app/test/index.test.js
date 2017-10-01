const tape = require('tape');
const server = require('../server/server.js');

tape('GET :: /', (t) => {
  server.inject('/')
    .then((res) => {
      t.equal(res.statusCode, 200);
      t.ok(res.payload.includes('Hello World'))
      t.end();
    });
});
