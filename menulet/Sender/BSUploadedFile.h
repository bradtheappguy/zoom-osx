//
//  BSUploadedFile.h
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSUploadedFile : NSObject {
}

-(id) initWithJSON:(id)json;
-(NSString *) fileName;

@property (readonly) NSString *page;
@property (readonly) NSDate *createdAt;
@property (readwrite) NSURL *originalFile;
@property (readonly) NSString *deleteToken;

@end
