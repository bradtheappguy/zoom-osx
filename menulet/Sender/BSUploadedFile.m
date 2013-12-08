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

- (void)encodeWithCoder:(NSCoder *)coder {
  [coder encodeObject:self.page forKey:@"kBSUploadedFilePage"];
  [coder encodeObject:self.createdAt forKey:@"kBSUploadedFileCreatedAt"];
  [coder encodeObject:self.originalFile forKey:@"kBSUploadedFileOriginalFile"];
  [coder encodeObject:self.deleteToken forKey:@"kBSUploadedFileDeleteToken"];
}

- (id)initWithCoder:(NSCoder *)coder {
  self = [super init];
  if (self) {
    _page = [coder decodeObjectForKey:@"kBSUploadedFilePage"];
    _createdAt = [coder decodeObjectForKey:@"kBSUploadedFileCreatedAt"];
    _originalFile = [coder decodeObjectForKey:@"kBSUploadedFileOriginalFile"];
    _deleteToken = [coder decodeObjectForKey:@"kBSUploadedFileDeleteToken"];
  }
  return self;
}



-(NSString *) fileName {
  return [[_originalFile path] lastPathComponent];
}

@end
