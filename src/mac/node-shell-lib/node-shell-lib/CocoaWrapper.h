//
//  CocoaWrapper.h
//  node-shell-lib
//
//  Created by Joel Brandt on 5/30/12.
//  Copyright (c) 2012 Adobe Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface ResultHolder : NSObject {
    NSMutableString* _result;
}
-(NSMutableString*) result;
@end

@interface CocoaWrapper : NSObject
+(NSString*) NSArrayToJSONString:(NSArray*) array;
+(void) showOpenDialogHelper:(ResultHolder*) rh;
@end

