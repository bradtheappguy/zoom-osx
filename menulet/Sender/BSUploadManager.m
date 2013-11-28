//
//  BSUploadManager.m
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import "BSUploadManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation BSUploadManager

+ (id)sharedInstance
{
  static dispatch_once_t once;
  static id sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

-(void) uploadFile:(NSString *)path {
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
  
  NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
  NSURLRequest *request = [NSURLRequest requestWithURL:URL];
  
  NSURL *filePath = [NSURL fileURLWithPath:path];
  NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
    } else {
      NSLog(@"Success: %@ %@", response, responseObject);
    }
  }];
  [uploadTask resume];
}
@end
