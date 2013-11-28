//
//  BSAppDelegate.m
//  SenderHelper
//
//  Created by Brad Smith on 11/28/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import "BSAppDelegate.h"

@implementation BSAppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
  NSString *appPath = [[[[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent] stringByDeletingLastPathComponent]  stringByDeletingLastPathComponent] stringByDeletingLastPathComponent];
  // get to the waaay top. Goes through LoginItems, Library, Contents, Applications
  [[NSWorkspace sharedWorkspace] launchApplication:appPath];
  [NSApp terminate:nil];
}

@end
