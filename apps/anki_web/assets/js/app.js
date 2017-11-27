// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
console.log('hello world');

function sync(type) {
  if (['notes', 'collection'].indexOf(type) === -1) {
    console.log('Choose a correct type');
    console.log('Instead got: ', type);
    return;
  }

  var xhr = new XMLHttpRequest();

  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4) {
      if (xhr.status === 200) {
        console.log('Successfully synchronized ' + type + '!');
      } else {
        console.log('Error: ', xhr.status);
      }
    }
  }

  xhr.open('post', '/api/synchronize');

  xhr.setRequestHeader('Content-Type', 'application/json;charset=UTF-8')
  xhr.setRequestHeader('x-csrf-token', csrfToken)

  xhr.send(JSON.stringify({ type }));
}

sync('collection');

// setTimeout(function () { sync('notes'); }, 4000);

