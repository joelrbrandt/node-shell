//
//  AppDelegate.h
//  node-shell
//
//  Created by Joel Brandt on 5/21/12.
//  Copyright (c) 2012 Adobe Systems. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *_window;
    WebView *_theWebView;
}

- (void)goToURL:(NSString *)url;

@property (assign) IBOutlet NSWindow *window;

@property (retain) IBOutlet WebView *theWebView;

@end
