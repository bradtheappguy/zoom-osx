//
//  BSCompletedStatusWindow.h
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BSCompletedStatusWindow : NSPanel

@property (nonatomic) IBOutlet NSTextField *textField;

+ (id)sharedInstance;

- (void) hide;
@end
