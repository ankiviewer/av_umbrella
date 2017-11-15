const assert = require('assert');
const { server } = require('./config.js');
const dbSetup = require('../test/setup.js');

server.start((err) => {
  assert(!err, err);

  if ((process.env.NODE_ENV || "").toUpperCase() === "TEST") {
    console.log("loading test data...");
    dbSetup()
      .then(() =>
        console.log('Test server running on ' + server.info.uri) // eslint-disable-line 
      );
  } else {
    console.log('Server running on ' + server.info.uri); // eslint-disable-line
  }
});
