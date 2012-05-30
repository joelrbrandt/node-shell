console.log('Current directory: ' + process.cwd());

/*
console.log('trying dynamic loading...');

var hello = require(process.cwd() + '/cocoanodetoo.app/Contents/Resources/hello');
console.log('here it is: ' + hello.hello("suck it"));
*/

var http = require('http');

var cocoa = require('./cocoanode');

var count = 0;

http.createServer(function (req, res) {
                  count++;
                  console.log('got a request:' + count)
                  res.writeHead(200, {'Content-Type': 'text/plain'});
                  res.end(cocoa.hello() + ': ' + count + '\n');
                  }).listen(1337, '127.0.0.1');
console.log('Server running at http://127.0.0.1:1337/');
console.log(process.versions);