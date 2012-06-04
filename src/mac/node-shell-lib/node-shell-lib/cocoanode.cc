//
//  cocoanode.mm
//  node-shell-lib
//
//  Created by Joel Brandt on 5/30/12.
//  Copyright (c) 2012 Adobe Systems. All rights reserved.
//

#import "CocoaWrapper_External.h"

#include <node.h>
#include <v8.h>

using namespace v8;

Handle<Value> getSomeFiles(const Arguments& args);
Handle<Value> redirect(const Arguments& args);
void init(Handle<Object> target);

Handle<Value> getSomeFiles(const Arguments& args) {
    HandleScope scope;
    const char* result = showOpenDialog();
    return scope.Close(String::New(result));
}

Handle<Value> redirect(const Arguments& args) {
    HandleScope scope;
    
    if (args.Length() < 1) {
        ThrowException(Exception::TypeError(String::New("Wrong number of arguments")));
        return scope.Close(Undefined());
    }
    
    if (!args[0]->IsNumber()) {
        ThrowException(Exception::TypeError(String::New("Wrong arguments")));
        return scope.Close(Undefined());
    }
    
    Local<Number> num = Number::New(args[0]->NumberValue());
    
    int port = num->Uint32Value();
    
    char url[256];
    sprintf(url, "http://localhost:%d/", port);
    goToURL(url);
    
    return scope.Close(Undefined());
}

void init(Handle<Object> target) {
    target->Set(String::NewSymbol("getSomeFiles"),
                FunctionTemplate::New(getSomeFiles)->GetFunction());
    target->Set(String::NewSymbol("redirect"),
                FunctionTemplate::New(redirect)->GetFunction());
}


NODE_MODULE(cocoanode, init)
