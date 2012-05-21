//
//  NodeWrapper.h
//  node-shell
//
//  Created by Joel Brandt on 5/21/12.
//  Copyright (c) 2012 Adobe Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NodeWrapper : NSObject {
    NSTask *task;
    NSMutableString *commandBuffer;
}

-(void) start;
-(void) stop;

-(void) receiveData: (NSNotification *)aNotification;
-(void) parseCommandBuffer;
-(void) processCommand: (NSString *)command;

-(void) sendCommand: (NSString *)command, ... NS_REQUIRES_NIL_TERMINATION;
-(void) sendData: (NSString *)dataString;

@end
