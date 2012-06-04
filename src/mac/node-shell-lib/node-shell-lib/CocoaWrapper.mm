//
//  CocoaWrapper.m
//  node-shell-lib
//
//  Created by Joel Brandt on 5/30/12.
//  Copyright (c) 2012 Adobe Systems. All rights reserved.
//

#import "AppDelegate.h"

#include "CocoaWrapper_External.h"
#import "CocoaWrapper.h"


@implementation ResultHolder

- (ResultHolder *)init
{
    [super init];
    _result = [[NSMutableString alloc] initWithString:@""];
    return self;
}

- (void)dealloc
{
    [_result release];
    [super dealloc];
}

- (NSMutableString*)result
{
    return _result;
}

@end


@implementation CocoaWrapper
+(NSString*) NSArrayToJSONString:(NSArray*) array {        
    int numItems = [array count];
    NSString* escapedStr = @"";
    NSMutableString* result = [[[NSMutableString alloc] initWithString:@"["] autorelease];
    NSString* item;
    
    for (int i = 0; i < numItems; i++)
    {
        [result appendString:@"\""];
        
        item = [array objectAtIndex:i];
        escapedStr = item; //EscapeJSONString(item, escapedStr);
        
        [result appendString:escapedStr];
        [result appendString:@"\""];
        
        
        if (i < numItems - 1)
            [result appendString:@", "];
    }
    [result appendString:@"]"];
    
    return result;
}

+(void) showOpenDialogHelper:(ResultHolder *) rh {
    NSString* result = @"";  
    NSArray* allowedFileTypes = nil;
    
    // Initialize the dialog
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setCanCreateDirectories:YES];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setTitle: @"Exciting times!"];
    
    [openPanel setAllowedFileTypes:allowedFileTypes];
    
    if ([openPanel runModal] == NSOKButton)
    {
        NSArray *f = [openPanel filenames];
        result = [CocoaWrapper NSArrayToJSONString:f];
    }
    
    [[rh result] setString:result];
}
@end

const char* showOpenDialog() {
    ResultHolder *rh = [[ResultHolder alloc] init];
    [CocoaWrapper performSelectorOnMainThread:@selector(showOpenDialogHelper:) withObject:rh waitUntilDone:YES];
    return [[rh result] UTF8String];
}

void goToURL(const char* url) {
    NSString* urlString = [[NSString alloc] initWithUTF8String:url];
    [[NSApp delegate] performSelectorOnMainThread:@selector(goToURL:) withObject:urlString waitUntilDone:NO];
    [urlString release];
}