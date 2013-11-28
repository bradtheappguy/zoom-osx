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
      NSLog(@"File uploaded to: %@",page);
      
      
      
      
      [[NSPasteboard generalPasteboard] clearContents];
      [[NSPasteboard generalPasteboard] setString:page  forType:NSStringPboardType];
      [[NSSound soundNamed:@"Ping"] play];
      
      BSCompletedStatusWindow *panel = [BSCompletedStatusWindow sharedInstance];
      NSRect windowFrame = [[panel screen] frame];
      
      [panel setFrame:NSMakeRect((windowFrame.size.width/2)-(panel.frame.size.width/2),
                                 (windowFrame.size.height/2)+(panel.frame.size.height/2),
                                 panel.frame.size.width,
                                 panel.frame.size.height) display:YES];
      
      

      
      [panel.textField setStringValue:[file fileName]];
      [panel setIsVisible:YES];
      
      [panel performSelector:@selector(hide) withObject:nil afterDelay:2.5];
      
      
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
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
    [[BSDataStore sharedInstance] removeFile:file];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    NSLog(@"failed to delete");
  }];
}
@end
