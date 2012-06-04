//
//  NodeWrapper.m
//  node-shell-lib
//
//  Created by Joel Brandt on 5/29/12.
//  Copyright (c) 2012 Adobe Systems. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "NodeWrapper.h"

#include "node.h"

@implementation NodeWrapper
+(void)startNode:(id)param{
    NSString *appPath = [[NSBundle mainBundle] bundlePath];
    NSString *webUrl = [appPath stringByAppendingString:@"/Contents/Resources/server.js"];
    
    /* enable to debug node */
    int argc = 3;
    char* argv[] = {(char *) "node", (char *) "--debug-brk", (char *) [webUrl UTF8String] };
    
    /* disable if the above is enabled
    int argc = 2;
    char* argv[] = {(char *) "node", (char *) [webUrl UTF8String] };
    */
    // end disable if the above is enabled
    
    node::Start(argc, argv);
}
+(void)logSomething:(NSString *) msg {
    NSLog(@"Logging something: %@", msg);
}
@end
