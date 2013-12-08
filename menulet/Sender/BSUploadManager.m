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
  
  NSString *uploadURLString = @"http://warm-rave.herokuapp.com/uploads.json";
  //NSString *uploadURLString = @"http://localhost:4000/uploads.json";
  
  NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:uploadURLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileURL:fileURL name:@"upload[attachment]" error:nil];
  }];
  
  
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
    CGFloat progress = ((CGFloat)totalBytesWritten) / totalBytesExpectedToWrite;
    NSLog(@"progress: %f",progress);
  }];
  
  
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    if (operation.response.statusCode == 200 || operation.response.statusCode == 201) {
      NSError *error = nil;
      id object = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
      if (!error && [object isKindOfClass:[NSDictionary class]]) {
        
        BSUploadedFile *file = [[BSUploadedFile alloc] initWithJSON:object];
        [file setOriginalFile:fileURL];
        
        [[BSDataStore sharedInstance] addUploadedFile:file];
        
        
        NSString *page = object[@"page"];
        
        [[NSPasteboard generalPasteboard] clearContents];
        [[NSPasteboard generalPasteboard] setString:page  forType:NSStringPboardType];
        
        NSString *soundName = [[BSDataStore sharedInstance] uploadSound];
        if (soundName) {
          NSSound *sound = [NSSound soundNamed:soundName];
          [sound play];
        }
        
        BSCompletedStatusWindow *panel = [BSCompletedStatusWindow sharedInstance];
        [panel displayMessage:NSLocalizedString(@"Uploaded", @"") WithFileName:[file fileName] duration:2.0];
      }
      else {
        NSLog(@"Network Error: Data is not a valid json opbject");
      }
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"Error: %@", error);
      [[BSCompletedStatusWindow sharedInstance] displayMessage:NSLocalizedString(@"Error - Upload Failed", @"") WithFileName:[fileURL path] duration:4.0];
    }];
  
  [[NSOperationQueue mainQueue] addOperation:operation];
  
  
}

-(void) uploadFile:(NSString *)filePath {
  NSURL *fileURL = [NSURL fileURLWithPath:filePath];
  [self uploadFileURL:fileURL];
}


- (void) deleteFile:(BSUploadedFile *)file {
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  NSString *deleteToken = [file deleteToken];
  
  if  (deleteToken) {
    [manager DELETE:file.page parameters:@{@"delete_token": deleteToken} success:^(AFHTTPRequestOperation *operation, id responseObject) {
      NSLog(@"Deleted");
      [[BSCompletedStatusWindow sharedInstance] displayMessage:NSLocalizedString(@"Deleted", @"") WithFileName:[file fileName] duration:2.0];
      [[BSDataStore sharedInstance] removeFile:file];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
      [[BSCompletedStatusWindow sharedInstance] displayMessage:NSLocalizedString(@"Error - Delete Failed", @"") WithFileName:[file fileName] duration:4.0];
    }];
  }
  else {
    NSLog(@"Error: Delete Token Missing.");
  }
}
@end
