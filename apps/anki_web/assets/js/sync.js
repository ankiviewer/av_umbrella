import { select, request } from './utils.js'

var socket = new Phoenix.Socket('/socket', {});

socket.connect();

select('#sync_button').addEventListener('click', function(_e) {
  var channel = socket.channel('sync:deck', {});

  select('.spinner').classList.remove('dn');
  select('.spinner > .message').innerHTML = 'Starting Sync...';

  channel.on('sync_msg', function (payload) {
    select('.spinner > .message').innerHTML = payload.body;

    if (payload.body === 'Synced!') {
      setTimeout(function () {
        select('.spinner').classList.add('dn');
      }, 500);
    }
  });

  channel.join()
    .receive('ok', function (resp) { console.log('ok: ', resp) } )
    .receive('error', function (resp) { console.log('error: ', resp); } );
});
