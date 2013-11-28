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
@end
