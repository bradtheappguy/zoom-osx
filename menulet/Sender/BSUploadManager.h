//
//  BSUploadManager.h
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSUploadedFile.h"

@interface BSUploadManager : NSObject

+ (id)sharedInstance;
- (void) uploadFileURL:(NSURL *)fileURL;
- (void) uploadFile:(NSString *)path;
- (void) deleteFile:(BSUploadedFile *)file;

@property CGFloat percentUploaded;

@end
