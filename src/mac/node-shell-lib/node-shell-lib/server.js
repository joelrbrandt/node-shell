console.log('Current directory: ' + process.cwd());

/*
console.log('trying dynamic loading...');

var hello = require(process.cwd() + '/cocoanodetoo.app/Contents/Resources/hello');
console.log('here it is: ' + hello.hello("suck it"));
*/

var http = require('http');

var hello = require('./hello');

http.createServer(function (req, res) {
                  res.writeHead(200, {'Content-Type': 'text/plain'});
                  res.end(hello.hello() + '\n');
                  }).listen(1337, '127.0.0.1');
console.log('Server running at http://127.0.0.1:1337/');
