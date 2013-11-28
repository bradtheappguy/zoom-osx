//
//  BSDataStore.h
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSDataStore : NSObject {
  NSArray *_recentlyUploadedFiles;
}

+ (id)sharedInstance;
- (NSArray *) recentlyUploadedFiles;

- (void) addUploadedFile:(id)file;
- (void) removeFile:(id)file;

@property (nonatomic, readwrite) BOOL autoUpdateScreenShots;

@property (nonatomic, readwrite) BOOL launchOnStartup;

@end
