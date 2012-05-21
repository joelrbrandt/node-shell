//
//  NodeWrapper.m
//  node-shell
//
//  Created by Joel Brandt on 5/21/12.
//  Copyright (c) 2012 Adobe Systems. All rights reserved.
//

#import "NodeWrapper.h"

@implementation NodeWrapper

- (void)dealloc
{
    [self stop];
    [task release];
    [super dealloc];
}

-(void) start {
    NSString *appPath = [[NSBundle mainBundle] bundlePath];
    NSString *nodePath = [appPath stringByAppendingString:@"/Contents/Resources/node-executable"];
    NSString *nodeJSPath = [appPath stringByAppendingString:@"/Contents/Resources/server.js"];
    
    NSLog(@"Here's where node is: %@\n", nodePath);
    
    task = [[NSTask alloc] init];
    [task setStandardOutput: [NSPipe pipe]];
    // [task setStandardError: [task standardOutput]];  // enable to pipe stderr to stdout
    
    
    [task setLaunchPath: nodePath];
    
    NSArray *arguments = [NSArray arrayWithObject:nodeJSPath];
    [task setArguments: arguments];
    
    // Here we register as an observer of the NSFileHandleReadCompletionNotification, which lets
    // us know when there is data waiting for us to grab it in the task's file handle (the pipe
    // to which we connected stdout and stderr above).  -getData: will be called when there
    // is data waiting.  The reason we need to do this is because if the file handle gets
    // filled up, the task will block waiting to send data and we'll never get anywhere.
    // So we have to keep reading data from the file handle as we go.
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(getData:) 
                                                 name: NSFileHandleReadCompletionNotification 
                                               object: [[task standardOutput] fileHandleForReading]];
    // We tell the file handle to go ahead and read in the background asynchronously, and notify
    // us via the callback registered above when we signed up as an observer.  The file handle will
    // send a NSFileHandleReadCompletionNotification when it has data that is available.
    [[[task standardOutput] fileHandleForReading] readInBackgroundAndNotify];
    
    [task launch];
    
}
-(void) stop {
    NSLog(@"Shutting down node process\n");
    
    NSData *data;
    
    // It is important to clean up after ourselves so that we don't leave potentially deallocated
    // objects as observers in the notification center; this can lead to crashes.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSFileHandleReadCompletionNotification object: [[task standardOutput] fileHandleForReading]];
    
    // Make sure the task has actually stopped!
    [task terminate];
    
    while ((data = [[[task standardOutput] fileHandleForReading] availableData]) && [data length])
    {
        NSLog(@"got some data: %@\n", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
    }
}

-(void) getData: (NSNotification *)aNotification
{
    NSData *data = [[aNotification userInfo] objectForKey:NSFileHandleNotificationDataItem];
    // If the length of the data is zero, then the task is basically over - there is nothing
    // more to get from the handle so we may as well shut down.
    if ([data length]) {
        // Send the data on to the controller; we can't just use +stringWithUTF8String: here
        // because -[data bytes] is not necessarily a properly terminated string.
        // -initWithData:encoding: on the other hand checks -[data length]
        
        NSLog(@"got some data: %@\n", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
    } else {
        // We're finished here
        [self stop];
    }
    
    // we need to schedule the file handle go read more data in the background again.
    [[aNotification object] readInBackgroundAndNotify];  
}

@end
