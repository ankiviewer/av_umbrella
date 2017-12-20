import { select, request } from './utils.js'

select('#sync_button').addEventListener('click', function(e) {
  const opts = {
    'content-type': 'application/json;charset=UTF-8',
    'x-csrf-token': csrfToken,
    payload: {type: 'collection'}
  };

  request.post('/api/synchronize', opts, function (err, res) {
    if (err) {
      console.log(err);
    }
    console.log('Result: ', res);
  });
});
