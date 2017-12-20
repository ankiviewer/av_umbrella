import { select, request } from './utils.js'

function sync(type, cb) {
  select('.spinner').classList.remove('dn');  

  select('.spinner > .message').innerHTML = 'Syncing ' + type + '...';

  const opts = {
    'content-type': 'application/json;charset=UTF-8',
    'x-csrf-token': csrfToken,
    payload: {type}
  };

  request.post('/api/synchronize', opts, function (err, res) {
    select('.spinner').classList.add('dn');

    cb(err, res);
  });
}

select('#sync_button').addEventListener('click', function(e) {
  sync('collection', function (err, res) {
    sync('notes', function (err, res) {
      console.log('DONE!');
    });
  });
});
