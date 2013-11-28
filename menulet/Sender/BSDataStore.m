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

-(id) init {
  if (self = [super init]) {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"RECENTLY_UPLOADED_FILES"];
    _recentlyUploadedFiles = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    _autoUpdateScreenShots = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AUTOUPLOAD_SCREENSHOTS"] boolValue];
    _launchOnStartup = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LAUNCH_ON_STARTUP"] boolValue];
  }
  return self;
}

- (NSArray *) recentlyUploadedFiles {
  return _recentlyUploadedFiles;
}

- (void) addUploadedFile:(id)file {
  if (!_recentlyUploadedFiles) {
    _recentlyUploadedFiles = [[NSMutableArray alloc] init];
  }
  [(NSMutableArray *)_recentlyUploadedFiles insertObject:file atIndex:0];
  while ([_recentlyUploadedFiles count] > 10) {
    id toRemove = [_recentlyUploadedFiles lastObject];
    [(NSMutableArray *)_recentlyUploadedFiles removeObject:toRemove];
  }
  
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATED_FILES" object:nil];
  
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_recentlyUploadedFiles];
  
  [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"RECENTLY_UPLOADED_FILES"];
}

- (void) removeFile:(id)file {
  [(NSMutableArray *)_recentlyUploadedFiles removeObject:file];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATED_FILES" object:nil];
}

-(void) setAutoUpdateScreenShots:(BOOL)autoUpdateScreenShots {
  _autoUpdateScreenShots = autoUpdateScreenShots;
  [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_autoUpdateScreenShots] forKey:@"AUTOUPLOAD_SCREENSHOTS"];
}

-(void) setLaunchOnStartup:(BOOL)launchOnStartup {
  _launchOnStartup = launchOnStartup;
  [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_launchOnStartup] forKey:@"LAUNCH_ON_STARTUP"];
}

@end
