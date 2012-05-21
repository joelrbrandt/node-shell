//
//  AppDelegate.m
//  node-shell
//
//  Created by Joel Brandt on 5/21/12.
//  Copyright (c) 2012 Adobe Systems. All rights reserved.
//

#import "AppDelegate.h"
#import "NodeWrapper.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NodeWrapper *node = [[NodeWrapper alloc] init];
    [node start];
}

@end
