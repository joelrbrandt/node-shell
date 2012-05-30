//
//  cocoanode.mm
//  node-shell-lib
//
//  Created by Joel Brandt on 5/30/12.
//  Copyright (c) 2012 Adobe Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#include <node.h>
#include <v8.h>

v8::Handle<v8::Value> getSomeFiles(const v8::Arguments& args);
void init(v8::Handle<v8::Object> target);
NSString* NSArrayToJSONString(NSArray* array);
NSString* showOpenDialog();


v8::Handle<v8::Value> getSomeFiles(const v8::Arguments& args) {
    v8::HandleScope scope;
    NSString* result = showOpenDialog();
    return scope.Close(v8::String::New([result UTF8String]));
}

void init(v8::Handle<v8::Object> target) {
    target->Set(v8::String::NewSymbol("getSomeFiles"),
                v8::FunctionTemplate::New(getSomeFiles)->GetFunction());
}

NSString* NSArrayToJSONString(NSArray* array) {        
    int numItems = [array count];
    NSString* escapedStr = @"";
    NSMutableString* result = [[[NSMutableString alloc] initWithString:@"["] autorelease];
    NSString* item;
    
    for (int i = 0; i < numItems; i++)
    {
        [result appendString:@"\""];
        
        item = [array objectAtIndex:i];
        escapedStr = item; //EscapeJSONString(item, escapedStr);
        
        [result appendString:escapedStr];
        [result appendString:@"\""];
        
        
        if (i < numItems - 1)
            [result appendString:@", "];
    }
    [result appendString:@"]"];
    
    return result;
}


NSString* showOpenDialog() {
    NSString* result = @"";  
    NSArray* allowedFileTypes = nil;
        
    // Initialize the dialog
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setCanCreateDirectories:YES];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setTitle: @"Exciting times!"];
    
    [openPanel setAllowedFileTypes:allowedFileTypes];
    
    if ([openPanel runModal] == NSOKButton)
    {
        NSArray *f = [openPanel filenames];
        result = NSArrayToJSONString(f);
    }
    
    return result;
}
NODE_MODULE(cocoanode, init)
