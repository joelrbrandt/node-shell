// hello.mm

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#include <node.h>
#include <v8.h>
    
v8::Handle<v8::Value> Method(const v8::Arguments& args) {
    v8::HandleScope scope;
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Delete the record?"];
    [alert setInformativeText:@"Deleted records cannot be restored."];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert runModal];
    return scope.Close(v8::String::New("world shmirld"));
}
    
void init(v8::Handle<v8::Object> target) {
    target->Set(v8::String::NewSymbol("hello"),
                v8::FunctionTemplate::New(Method)->GetFunction());
}
NODE_MODULE(hello, init)
    
