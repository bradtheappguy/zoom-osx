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
    loginController  = [[StartAtLoginController alloc] initWithIdentifier:@"com.bradsmithinc.sender.helper"];

    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"RECENTLY_UPLOADED_FILES"];
    if (data) {
       _recentlyUploadedFiles = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
   
    
    _autoUpdateScreenShots = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AUTOUPLOAD_SCREENSHOTS"] boolValue];
    _launchOnStartup = [loginController startAtLogin];
    
    _uploadSound = [[NSUserDefaults standardUserDefaults] objectForKey:@"SOUND"];
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
  if (file) {
    [(NSMutableArray *)_recentlyUploadedFiles insertObject:file atIndex:0];
  }
  
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
  loginController.startAtLogin = _launchOnStartup;
}

-(NSArray *) availableSounds {
  NSMutableArray *arr = [[NSMutableArray alloc] init];
  
  NSFileManager *fileManager = [[NSFileManager alloc] init];
  NSURL *directoryURL = [NSURL fileURLWithPath:@"/System/Library/Sounds"];
  NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
  
  NSDirectoryEnumerator *enumerator = [fileManager
                                       enumeratorAtURL:directoryURL
                                       includingPropertiesForKeys:keys
                                       options:0
                                       errorHandler:^(NSURL *url, NSError *error) {
                                         // Handle the error.
                                         // Return YES if the enumeration should continue after the error.
                                         return YES;
                                       }];
  
  for (NSURL *url in enumerator) {
    NSString *filename = [[[url absoluteString] lastPathComponent] stringByDeletingPathExtension];
    if (filename) {
      [arr addObject:filename];
    }
  }
  
 
  return arr;
}

-(void) setUploadSound:(NSString *)sound {
  _uploadSound = sound;
  [[NSSound soundNamed:sound] play];
  [[NSUserDefaults standardUserDefaults] setObject:_uploadSound forKey:@"SOUND"];
}

-(NSString *)defaultUploadSound {
  return @"Ping";
}

@end
