//
//  BSDataStore.m
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import "BSDataStore.h"

@implementation BSDataStore

+ (id)sharedInstance
{
  static dispatch_once_t once;
  static id sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (NSArray *) recentlyUploadedFiles {
  return _recentlyUploadedFiles;
}

- (void) addUploadedFile:(id)file {
  if (!_recentlyUploadedFiles) {
    _recentlyUploadedFiles = [[NSMutableArray alloc] init];
  }
  [(NSMutableArray *)_recentlyUploadedFiles addObject:file];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATED_FILES" object:nil];
}

@end
