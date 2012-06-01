var fs = require('fs'), path = require('path');

function grepFile(contents, queryExpr) {
    // Quick exit if not found
    if (contents.search(queryExpr) === -1) {
        return null;
    }
    
    var trimmedContents = contents;
    var startPos = 0;
    var matchStart;
    var matches = [];
    
    function getLineNum(offset) {
        return contents.substr(0, offset).split("\n").length - 1; // 0 based linenum
    }
    
    function getLine(lineNum) {
        // Future: cache result 
        return contents.split("\n")[lineNum];
    }
    
    var match;
    while ((match = queryExpr.exec(contents)) !== null) {
        var lineNum = getLineNum(match.index);
        var line = getLine(lineNum);
        var ch = match.index - contents.lastIndexOf("\n", match.index) - 1;  // 0-based index
        var matchLength = match[0].length;
        
        // Don't store more than 200 chars per line
        line = line.substr(0, Math.min(200, line.length));
        
        matches.push({
            start: {line: lineNum, ch: ch},
            end: {line: lineNum, ch: ch + matchLength},
            line: line
        });
    }

    return matches;
}

function _getQueryRegExp(query) {
    // If query is a regular expression, use it directly
    var isRE = query.match(/^\/(.*)\/(g|i)*$/);
    if (isRE) {
        // Make sure the 'g' flag is set
        var flags = isRE[2] || "g";
        if (flags.search("g") === -1) {
            flags += "g";
        }
        return new RegExp(isRE[1], flags);
    }

    // Query is a string. Turn it into a case-insensitive regexp
    
    // Escape regex special chars
    query = query.replace(/(\(|\)|\{|\}|\[|\]|\.|\^|\$|\||\?|\+|\*)/g, "\\$1");
    return new RegExp(query, "gi");
}

function grepDir(dir, needle) {
    var results = [];
    var files = fs.readdirSync(dir);
    var i, j, s, matches;
    for (i = 0; i < files.length; i++) {
        var filename = path.join(dir, files[i]);
        //console.log("looking at " + filename);
        var stat = fs.statSync(filename);
        if (stat.isFile()) {
            // grep it
            try {
                s = fs.readFileSync(filename, 'utf8');
                matches = grepFile(s, needle);
                if (matches && matches.length) {
                    results.push({
                        fullPath: filename,
                        matches: matches
                    });
                }

            } catch (e) {
                console.log("Error: couldn't read " + filename);
                console.log(e);
            }
        } else if (stat.isDirectory()) {
            // recurse
            results = results.concat(grepDir(filename, needle));
        }
    }
    return results;
}

exports.grepDir = function(dir, query) { return grepDir(dir, _getQueryRegExp(query)) };
