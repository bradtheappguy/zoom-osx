//
//  BSUploadManager.m
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import "BSUploadManager.h"
#import "BSCompletedStatusWindow.h"
#import "BSDataStore.h"

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


- (void) uploadFileURL:(NSURL *)fileURL {
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  
  //NSString *uploadURLString = @"http://warm-rave.herokuapp.com/uploads.json";
  NSString *uploadURLString = @"http://localhost:4000/uploads.json";
  
  [manager POST:uploadURLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileURL:fileURL name:@"upload[attachment]" error:nil];
  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    if ([NSJSONSerialization isValidJSONObject:responseObject]) {
      
      
      BSUploadedFile *file = [[BSUploadedFile alloc] initWithJSON:responseObject];
      [file setOriginalFile:fileURL];
      
      [[BSDataStore sharedInstance] addUploadedFile:file];
      
      
      NSString *page = responseObject[@"page"];

      [[NSPasteboard generalPasteboard] clearContents];
      [[NSPasteboard generalPasteboard] setString:page  forType:NSStringPboardType];
      [[NSSound soundNamed:[[BSDataStore sharedInstance] uploadSound]] play];
      
      BSCompletedStatusWindow *panel = [BSCompletedStatusWindow sharedInstance];
      [panel displayMessage:NSLocalizedString(@"Uploaded", @"") WithFileName:[file fileName] duration:2.0];
      
      
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
    [[BSCompletedStatusWindow sharedInstance] displayMessage:NSLocalizedString(@"Error - Upload Failed", @"") WithFileName:[fileURL path] duration:4.0];
  }];

}

-(void) uploadFile:(NSString *)filePath {
  NSURL *fileURL = [NSURL fileURLWithPath:filePath];
  [self uploadFileURL:fileURL];
}


- (void) deleteFile:(BSUploadedFile *)file {
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  [manager DELETE:file.page parameters:@{@"delete_token": file.deleteToken} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"Deleted");
    [[BSCompletedStatusWindow sharedInstance] displayMessage:NSLocalizedString(@"Deleted", @"") WithFileName:[file fileName] duration:2.0];
    [[BSDataStore sharedInstance] removeFile:file];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    [[BSCompletedStatusWindow sharedInstance] displayMessage:NSLocalizedString(@"Error - Delete Failed", @"") WithFileName:[file fileName] duration:4.0];
  }];
}
@end
