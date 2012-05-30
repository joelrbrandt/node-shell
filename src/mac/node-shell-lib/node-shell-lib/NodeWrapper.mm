//
//  NodeWrapper.m
//  node-shell-lib
//
//  Created by Joel Brandt on 5/29/12.
//  Copyright (c) 2012 Adobe Systems. All rights reserved.
//

#import "NodeWrapper.h"
#include "node.h"

@implementation NodeWrapper
+(void)startNode:(id)param{
    NSString *appPath = [[NSBundle mainBundle] bundlePath];
    NSString *webUrl = [appPath stringByAppendingString:@"/Contents/Resources/server.js"];
    
    int argc = 2;
    char* argv[] = {(char *) "node", (char *) [webUrl UTF8String] };
    
    node::Start(argc, argv);
}
@end
