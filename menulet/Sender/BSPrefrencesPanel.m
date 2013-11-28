//
//  BSPrefrencesPanel.m
//  Sender
//
//  Created by Brad Smith on 11/28/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import "BSPrefrencesPanel.h"
#import "BSDataStore.h"
@implementation BSPrefrencesPanel

static id sharedInstance = nil;

+ (id)sharedInstance
{
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

-(void) awakeFromNib {
  if (!sharedInstance) {
    sharedInstance = self;
  }
  [self setLevel:kCGPopUpMenuWindowLevel];
  if ([[BSDataStore sharedInstance] launchOnStartup]) {
    [self.launchAtLoginCheckbox setState:NSOnState];
  }
  else {
    [self.launchAtLoginCheckbox setState:NSOffState];
  }
}
- (IBAction)launchAtLoginCheckboxWasClicked:(NSButton *)sender {
  if (NO == [sender state]) {
    [[BSDataStore sharedInstance] setLaunchOnStartup:NO];
  }
  else {
    
    [[BSDataStore sharedInstance] setLaunchOnStartup:YES];
  }
}
@end
