//
//  ShellMenus.h
//  node-shell
//
//  Created by Glenn Ruehle on 5/25/12.
//  Copyright 2012 Adobe Systems. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface ShellMenus : NSObject {
    NSMutableDictionary *menuDict;
    NSMutableDictionary *menuItemDict;
}

    -(void) runCommand:(id) sender;

    -(void) addMenu:(NSString*) id name: (NSString*) name position: (NSString*) position relativeID: (NSString*) relativeID;
    -(void) addMenuItem: (NSString*) parentMenuId id:(NSString*) id name:(NSString*) name command:(NSString*) command keyBindings:(NSString*) keyBindings position:(NSString*) position relativeID:(NSString*) relativeID;
    -(void) setMenuItemEnabled: (NSString*) id enabled:(BOOL) enabled;
    -(void) setMenuItemChecked: (NSString*) id checked:(BOOL) checked;
@end
