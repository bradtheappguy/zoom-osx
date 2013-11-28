//
//  BSAppDelegate.h
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BSAppDelegate : NSObject <NSApplicationDelegate> {
  NSStatusItem *theItem;
}

@property (assign) IBOutlet NSWindow *window;

@end
