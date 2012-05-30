//
//  ShellMenus.m
//  node-shell
//
//  Created by Glenn Ruehle on 5/25/12.
//  Copyright 2012 Adobe Systems. All rights reserved.
//

#import "ShellMenus.h"
#import "NodeWrapper.h"

@interface ShellMenuItem : NSMenuItem {
    NSString* id_;
    NSString* command_;
}

- (NSString*) id;
- (void) setId: (NSString*)value;

- (NSString*) command;
- (void) setCommand: (NSString*)value;

@end

@implementation ShellMenuItem

- (NSString*) id {
    return id_;
}

- (void) setId:(NSString*)value {
    [id_ autorelease];
    id_ = [value retain];
}

- (NSString*) command {
    return command_;
}

- (void) setCommand:(NSString*)value {
    [command_ autorelease];
    command_ = [value retain];
}

@end

@implementation ShellMenus

-(id) init {
    if (self = [super init]) {
        menuDict = [[NSMutableDictionary alloc] init];
        menuItemDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc {
    [menuDict release];
    [menuItemDict release];
    [super dealloc];
}
    
-(void) runCommand:(id)sender {
    [[NodeWrapper getNodeWrapper] sendCommand: @"runCommand", [sender command], nil];
}


-(void) addMenu:(NSString*) id name: (NSString*) name position: (NSString*) position relativeID: (NSString*) relativeID
{
    NSMenu* newMenu = [[NSMenu alloc] initWithTitle:name];    
    ShellMenuItem* newItem = [[ShellMenuItem alloc] initWithTitle:name action:nil keyEquivalent:@""];
    [newMenu setAutoenablesItems: false];
    [newItem setSubmenu: newMenu];
    [newMenu release];
    [[NSApp mainMenu] addItem: newItem];
    [menuDict setValue: newMenu forKey: id];
    [newItem release];
}

-(void) addMenuItem: (NSString*) parentMenuId id:(NSString*) id name:(NSString*) name command:(NSString*) command keyBindings:(NSString*) keyBindings position:(NSString*) position relativeID:(NSString*) relativeID
{
    NSMenu* menu = [menuDict valueForKey: parentMenuId];

    if ([name isEqualToString:@"---"]) {
        NSMenuItem* separator = [NSMenuItem separatorItem];
        [menu addItem: separator];
        return;
    }
    
    // TODO: Decode key bindings
    if ([keyBindings length] == 6 && [keyBindings hasPrefix: @"Ctrl-"]) {
        keyBindings = [[NSString stringWithString: [keyBindings substringFromIndex: 5]] lowercaseString];
    } else if ([keyBindings length] == 12 && [keyBindings hasPrefix: @"Ctrl-Shift-"]) {
        keyBindings = [[NSString stringWithString: [keyBindings substringFromIndex: 11]] uppercaseString];
    } 
    ShellMenuItem* newItem = [[ShellMenuItem alloc] initWithTitle: name action: nil keyEquivalent: keyBindings];
    
    [newItem setId: id];
    [newItem setCommand: command];
    [newItem setTarget: self];
    [newItem setAction: @selector(runCommand:)];
    [menu addItem: newItem];
    
    [menuItemDict setValue: newItem forKey: id];
    
    [newItem release];
}

-(void) setMenuItemEnabled: (NSString*) id enabled:(BOOL) enabled
{
    ShellMenuItem* item = [menuItemDict valueForKey: id];
    [item setEnabled: enabled];
}

-(void) setMenuItemChecked: (NSString*) id checked:(BOOL) checked
{
    ShellMenuItem* item = [menuItemDict valueForKey: id];
    [item setState: checked ? NSOnState : NSOffState];
}
@end
