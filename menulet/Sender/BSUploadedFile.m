//
//  BSUploadedFile.m
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import "BSUploadedFile.h"


@implementation BSUploadedFile

-(id) initWithJSON:(id)json {
  if (self = [super init]) {
    _page = json[@"page"];
    
    NSString *unformattedDate = json[@"created_at"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                      //2013-11-28T08:09:09.157Z
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSz"];
    _createdAt = [df dateFromString:unformattedDate];
    _deleteToken = json[@"delete_token"];
    
  }
  return self;
}

-(NSString *) fileName {
  NSURLComponents *components = [NSURLComponents componentsWithURL:_originalFile resolvingAgainstBaseURL:NO];
  NSArray *parts = [[components path] componentsSeparatedByString:@"/"];
  NSString *filename = [parts lastObject];
  return filename;
}

@end
