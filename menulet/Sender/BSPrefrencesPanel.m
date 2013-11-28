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
  return sharedInstance;
}

-(void) awakeFromNib {
  if (!sharedInstance) {
    sharedInstance = self;
  }
  //[self setLevel:kCGPopUpMenuWindowLevel];
  if ([[BSDataStore sharedInstance] launchOnStartup]) {
    [self.launchAtLoginCheckbox setState:NSOnState];
  }
  else {
    [self.launchAtLoginCheckbox setState:NSOffState];
  }
  
  [self setReleasedWhenClosed:NO];
  
  [self.soundButton setAutoenablesItems:NO];
  
  NSArray *sounds = [[BSDataStore sharedInstance] availableSounds];
  [self.soundButton addItemsWithTitles:sounds];
  NSString *sound = [[BSDataStore sharedInstance] uploadSound];
  if (sound) {
    [self.soundButton setTitle:sound];
  }
  else {
    [self.soundButton setTitle:[[BSDataStore sharedInstance] defaultUploadSound]];
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

-(IBAction)performSoundMenuClicl:(id)sender {
  NSString *sound = [sender titleOfSelectedItem];
  [sender setTitle:sound];
  [sender synchronizeTitleAndSelectedItem];
  [[BSDataStore sharedInstance] setUploadSound:sound];
}
@end
