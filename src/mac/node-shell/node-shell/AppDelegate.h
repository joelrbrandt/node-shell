//
//  AppDelegate.h
//  node-shell
//
//  Created by Joel Brandt on 5/21/12.
//  Copyright (c) 2012 Adobe Systems. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *_window;
}

@property (assign) IBOutlet NSWindow *window;

@end