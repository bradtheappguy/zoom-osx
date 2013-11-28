//
//  BSUploadManager.h
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSUploadManager : NSObject

+ (id)sharedInstance;
- (void) uploadFile:(NSString *)path;

@end
