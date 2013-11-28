//
//  BSCompletedStatusWindow.m
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import "BSCompletedStatusWindow.h"

@implementation BSCompletedStatusWindow

static id sharedInstance;

+ (id)sharedInstance
{
  NSAssert(self, @"This singleton needs to be created in a xib");
  return sharedInstance;
}

-(void) awakeFromNib {
  sharedInstance = self;
  NSLog(@"awake");
  [self setLevel:kCGPopUpMenuWindowLevel];
}

- (BOOL)isMovable {
  return false;
}

-(void) hide {
  [self setIsVisible:NO];
}

-(void) displayMessage:(NSString *)message WithFileName:(NSString *)fileName duration:(CGFloat)duration {
  NSRect windowFrame = [[self screen] frame];
  
  [self setFrame:NSMakeRect((windowFrame.size.width/2)-(self.frame.size.width/2),
                             (windowFrame.size.height/2)+(self.frame.size.height/2),
                             self.frame.size.width,
                             self.frame.size.height) display:YES];
  
  
  
  [self.titleTextField setStringValue:message];
  [self.textField setStringValue:fileName];
  [self setIsVisible:YES];
  
  [self performSelector:@selector(hide) withObject:nil afterDelay:duration];
}

@end
