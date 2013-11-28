//
//  BSPrefrencesPanel.m
//  Sender
//
//  Created by Brad Smith on 11/28/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import "BSPrefrencesPanel.h"

@implementation BSPrefrencesPanel

+ (id)sharedInstance
{
  static dispatch_once_t once;
  static id sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

@end
