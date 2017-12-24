var homeNode = document.querySelector('#home');
var homeApp = Elm.Home.embed(homeNode);

var socket = new Phoenix.Socket('/socket', {});

socket.connect();

homeApp.ports.sync.subscribe(function (o) {
  var channel = socket.channel('sync:deck', {});

  channel.on('sync_msg', function (payload) {
    homeApp.ports.syncMessage.send(payload.body);
  });

  channel.join()
    .receive('ok', function () {})
    .receive('error', console.error);
});

