//
//  BSDataStore.h
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StartAtLoginController.h"

@interface BSDataStore : NSObject {
  NSArray *_recentlyUploadedFiles;
  StartAtLoginController *loginController;
}

+ (id)sharedInstance;
- (NSArray *) recentlyUploadedFiles;

- (void) addUploadedFile:(id)file;
- (void) removeFile:(id)file;
-(NSArray *) availableSounds;

-(NSString *)defaultUploadSound;

@property (nonatomic, readwrite) BOOL autoUpdateScreenShots;

@property (nonatomic, readwrite) BOOL launchOnStartup;

@property (nonatomic, readwrite) NSString *uploadSound;

@end
