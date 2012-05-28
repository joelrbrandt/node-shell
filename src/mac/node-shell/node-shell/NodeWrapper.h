//
//  NodeWrapper.h
//  node-shell
//
//  Created by Joel Brandt on 5/21/12.
//  Copyright (c) 2012 Adobe Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface NodeWrapper : NSObject {
    NSTask *task;
    NSMutableString *commandBuffer;
    unsigned int commandCount;
}

-(void) start;
-(void) stop;

-(void) receiveData: (NSNotification *)aNotification;
-(void) parseCommandBuffer;
-(void) processCommand: (NSString *)command;

-(void) sendCommand: (NSString *)command, ... NS_REQUIRES_NIL_TERMINATION;
-(void) sendData: (NSString *)dataString;

-(NSString*) showOpenDialog: (BOOL) allowMultipleSelection chooseDirectory: (BOOL) chooseDirectory andTitle: (NSString*) title withInitialPath: (NSString*) initialPath andFileTypes: (NSString*) fileTypesStr;
-(NSString*) NSArrayToJSONString: (NSArray*) array;
@end
