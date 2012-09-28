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
/*global global, require, exports, process, setInterval */

var fs = require('fs');
var cocoa = require('./cocoanode');

var websocket = null;

// add some stuff to fs because the return types are sometimes complicated objects that don't jsonify
fs.statBrackets = function (path, callback) {
    fs.stat(path, function (err, stats) {
        var result;
        if (err) {
            callback(err, null);
        } else {
            result = {};
            result.isFile = stats.isFile();
            result.isDirectory = stats.isDirectory();
            result.mtime = stats.mtime;
            result.filesize = stats.size;
            callback(0, result); // TODO: hack, need handling of error being null in callbacks on client side
        }
    });
};

// A test namespace

var test = {};

test.reverse = function (s) {
    return s.split("").reverse().join("");
};

// end test namespace

// app namespace

var app = {};

app.showOpenDialog = function(allowMultipleSelection, chooseDirectory, title, initialPath, fileTypes, callback) {
    console.log("trying to get some files");
    var files = cocoa.getSomeFiles();
    console.log("got some files: " + files);
    callback(null, JSON.parse(files));
}

var namespaces = {
    app : app,
    fs : fs,
    test : test
};

function createCallback(id, ws) {
    return function () {
        var args = Array.prototype.slice.call(arguments);
        if (websocket !== null) {
            // console.warn("Sending callback for " + id + " with args " + args);
            websocket.send(JSON.stringify({id: id, result: args}));
        }
    };
}

function doCommand(id, namespace, command, args, isAsync, ws) {
    try {
        var f = namespaces[namespace][command];
        var callback = createCallback(id, ws);
        if (isAsync) {
            args.push(callback);
            f.apply(global, args);
        } else {
            callback(f.apply(global, args));
        }
    } catch (e) {
        console.log("Error: Couldn't run the command " + namespace + "." + command + " with args " + JSON.stringify(args));
    }
}

function receiveData(message) {
    var m;
    //console.log('received: %s', message);
    try {
        m = JSON.parse(message);
        //console.log('parsed version:');
        //console.log(m);
        doCommand(m.id, m.namespace, m.command, m.args, m.isAsync);
    } catch (e) {
        console.log("Error: could't parse the message or something");
    }
}

function setWebsocket(ws) {
    console.warn("setting new websocket");
    if (websocket !== null) {
        websocket.close();
    }
    websocket = ws;
    websocket.on('message', function (message) {
        var m;
        //console.log('received: %s', message);
        try {
            m = JSON.parse(message);
            //console.log('parsed version:');
            //console.log(m);
            doCommand(m.id, m.namespace, m.command, m.args, m.isAsync, ws);
        } catch (e) {
            console.log("Error: could't parse the message or something");
        }
    });
}

function addNamespace(name, functions) {
    namespaces[name] = functions;
}

exports.setWebsocket = setWebsocket;
exports.addNamespace = addNamespace