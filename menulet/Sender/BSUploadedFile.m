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
  }
  return self;
}
@end
