/*
 * Copyright (c) 2012 Adobe Systems Incorporated. All rights reserved.
 *  
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"), 
 * to deal in the Software without restriction, including without limitation 
 * the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 * and/or sell copies of the Software, and to permit persons to whom the 
 * Software is furnished to do so, subject to the following conditions:
 *  
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *  
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
 * DEALINGS IN THE SOFTWARE.
 * 
 */

/*jslint sloppy: true, vars: true, plusplus: true, devel: true, nomen: true, indent: 4, maxerr: 50 */
/*global require, process, setInterval */

var count = 0;
var commandBuffer = "";

// write to stdout and stderror so we can make sure they're going to the right place when debugging
process.stdout.write('this is stdout\n\n');
process.stderr.write('this is stderr\n\n');

function processCommand(command) {
    var args = command.split('|');
    if (args.length > 0) {
        if (args[0] === 'pong') {
            console.warn('got pong response: ' + JSON.stringify(args));
        } else {
            console.warn('got an unknown command: ' + command);
        }
    }
}

function parseCommandBuffer() {
    var command;
    var i = commandBuffer.indexOf("\n\n");
    while (i >= 0) {
        command = commandBuffer.substr(0, i);
        commandBuffer = commandBuffer.substr(i + 2);
        processCommand(command);
        i = commandBuffer.indexOf("\n\n");
    }
}

function sendCommand() {
    var commandString = Array.prototype.join.call(arguments, "|");
    commandString += "\n\n";
    console.warn("sending from node: " + commandString);
    process.stdout.write(commandString);
}

// re-enable getting events from stdin
process.stdin.resume();
process.stdin.setEncoding('utf8');

// set up event handlers for stdin
process.stdin.on('data', function receiveData(chunk) {
    process.stderr.write('node got some data: ' + chunk);
    commandBuffer += chunk;
    parseCommandBuffer();
});

process.stdin.on('end', function receiveStdInClose() {
    sendCommand('end\n\n');
    process.exit(0);
});

// set up a really simple web server
var http = require('http');
http.createServer(function (req, res) {
    console.log('got a web request');
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end('Hello World\n');
}).listen(1337, '127.0.0.1');
console.log('Server running at http://127.0.0.1:1337/');


// Routinely check if stdout is closed. If it's closed, our parent process exited, so we should too.
setInterval(function () {
    count++;
    if (!process.stdout.writable) {
        process.exit(0);
    } else {
        sendCommand('ping', 'asdf', count);
    }
}, 1000);
