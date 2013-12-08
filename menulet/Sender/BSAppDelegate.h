//
//  BSAppDelegate.h
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HockeySDK/HockeySDK.h>

@protocol BITHockeyManagerDelegate;

@interface BSAppDelegate : NSObject <NSApplicationDelegate, NSMetadataQueryDelegate, BITHockeyManagerDelegate> {
  NSStatusItem *theItem;
  NSMetadataQuery *query;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, copy) NSArray *queryResults;

@end
