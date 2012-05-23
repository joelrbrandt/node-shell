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

@synthesize theWebView = _theWebView;

- (void)dealloc
{
    [super dealloc];
}

- (void)goToURL:(NSString *)url
{
    NSURLRequest* myRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [[self.theWebView mainFrame] loadRequest:myRequest];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NodeWrapper *node = [[NodeWrapper alloc] init];
    [node start];
}

@end
