function _request (method, url, options, cb) {
  var xhr = new XMLHttpRequest();

  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4) {
      cb(xhr.status !== 200, JSON.parse(xhr.response));
    }
  }

  xhr.open(method, url);

  for (var key in options) {
    if(key !== 'payload') {
      xhr.setRequestHeader(key, options[key]);
    }
  }

  xhr.send(JSON.stringify(options.payload || {}));
}

/**
 * Request library
 *
 * Example:
 *
 * request.get('/api/user', {
 *   'content-type': 'application/json;charset=UTF-8',
 *   'x-csrf-token': csrfToken
 * }, (err, res) => console.log(res));
 * 
 * request.post('/api/synchronize/notes', {
 *   'content-type': 'application/json;charset=UTF-8',
 *   'payload': {}
 * }
 *
 * @method get|post|put|delete
 * @param {string} request url path
 * @param {object} options object
 * @param {function} cb function with signature:
 *   @param {boolean} error status
 *   @param {object} response object
 */
const request = {
  get: function (url, options, cb) { return _request('get', url, options, cb); },
  post: function (url, options, cb) { return _request('post', url, options, cb); },
  put: function (url, options, cb) { return _request('put', url, options, cb); },
  delete: function (url, options, cb) { return _request('delete', url, options, cb); },
}

export default request;
