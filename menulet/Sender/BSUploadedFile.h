//
//  BSUploadedFile.h
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSUploadedFile : NSObject {
  NSString *_page;
}

-(id) initWithJSON:(id)json;

@property (readonly) NSString *page;

@end
