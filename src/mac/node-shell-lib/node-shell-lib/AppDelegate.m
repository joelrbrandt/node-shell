//
//  AppDelegate.m
//  node-shell-lib
//
//  Created by Joel Brandt on 5/29/12.
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
    // Insert code here to initialize your application
    [NSThread detachNewThreadSelector:@selector(startNode:) toTarget:[NodeWrapper class] withObject:nil];
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Delete the record?"];
    [alert setInformativeText:@"Deleted records cannot be restored."];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert runModal];
}

@end
