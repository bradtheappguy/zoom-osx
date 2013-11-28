//
//  BSPrefrencesPanel.h
//  Sender
//
//  Created by Brad Smith on 11/28/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BSPrefrencesPanel : NSPanel

+ (id)sharedInstance;

@property (weak) IBOutlet NSButton *launchAtLoginCheckbox;
@end
