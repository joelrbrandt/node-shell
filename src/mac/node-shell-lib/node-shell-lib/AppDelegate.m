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
@synthesize theWebView = _theWebView;

- (void)dealloc
{
    [super dealloc];
}

- (void) goToURL:(NSString*) url
{
    NSURLRequest* myRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [[_theWebView mainFrame] loadRequest:myRequest];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [NSThread detachNewThreadSelector:@selector(startNode:) toTarget:[NodeWrapper class] withObject:nil];
}

@end
