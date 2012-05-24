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
/*global require, exports, process, setInterval */

var count = 0;
var commandBuffer = "";
var pendingCallbacks = {};
var clientProxy = null;

function processCommand(command) {
    var args = command.split('|');
    var commandId, commandName;
    if (args.length > 1) {
        commandId = args[0];
        commandName = args[1];
        if (commandName === 'pong') {
            console.warn('got pong response: ' + JSON.stringify(args));
        } else if (commandName === 'invokeCallback') {
            var id = args[2];
            if (pendingCallbacks[id]) {
				var callbackArgs = [], i;
				for (i = 3; i < args.length; i++) {
					callbackArgs[i - 3] = JSON.parse(args[i]);
				}
                pendingCallbacks[id].apply(global, callbackArgs);
                delete pendingCallbacks[id];
            }
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
        if (command.length > 0) {
            processCommand(command);
        }
        i = commandBuffer.indexOf("\n\n");
    }
}

function sendCommand() {
    var commandString = "\n\n" + count + "|" + Array.prototype.join.call(arguments, "|") + "\n\n";
    // we send newlines before and after in case something was in the pipe that wasn't a command
    console.warn("sending from node: " + commandString);
    process.stdout.write(commandString);
    count++;
}

function sendAsyncCommand(callback) {
    pendingCallbacks[count] = callback;
    var args = Array.prototype.slice.call(arguments, 1);
    sendCommand.apply(global, args);
}

function receiveData(chunk) {
    process.stderr.write('node got some data: ' + chunk);
    commandBuffer += chunk;
    parseCommandBuffer();
}

exports.receiveData = receiveData;
exports.sendCommand = sendCommand;
exports.sendAsyncCommand = sendAsyncCommand;
exports.setClientProxy = function (cp) { clientProxy = cp; };
