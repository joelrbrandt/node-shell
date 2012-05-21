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
}

-(void) start;
-(void) stop;
-(void) getData: (NSNotification *)aNotification;

@end
