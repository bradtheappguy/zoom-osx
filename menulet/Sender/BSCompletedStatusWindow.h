//
//  BSCompletedStatusWindow.h
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BSCompletedStatusWindow : NSWindow

@property (nonatomic) IBOutlet NSTextField *titleTextField;
@property (nonatomic) IBOutlet NSTextField *textField;

+ (id)sharedInstance;

- (void) hide;

-(void) displayMessage:(NSString *)message WithFileName:(NSString *)fileName duration:(CGFloat)duration;
@end

