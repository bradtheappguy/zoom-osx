//
//  BSAppDelegate.m
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import "BSAppDelegate.h"
#import "BSUploadManager.h"
#import "BSDataStore.h"
#import "PFMoveApplication.h"


@implementation BSAppDelegate





- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"0b9063efcb5284eafc11c54780a5e7e4" companyName:@"Brad Smith" delegate:self];
  [[BITHockeyManager sharedHockeyManager].crashManager setAutoSubmitCrashReport: YES];
  [[BITHockeyManager sharedHockeyManager] startManager];
  
  
  [NSApp setServicesProvider:self];
  
  PFMoveToApplicationsFolderIfNecessary();
  query = [[NSMetadataQuery alloc] init];
  
  //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryUpdated:) name:NSMetadataQueryDidStartGatheringNotification object:query];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryUpdated:) name:NSMetadataQueryDidUpdateNotification object:query];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryUpdated:) name:NSMetadataQueryDidFinishGatheringNotification object:query];
  
  [query setDelegate:self];
  [query setPredicate:[NSPredicate predicateWithFormat:@"(kMDItemIsScreenCapture = 1) && (kMDItemFSCreationDate > '$time.now')"]];
  [query startQuery];

}


-(void) applicationWillTerminate:(NSNotification *)notification {
  [query stopQuery];
  [query setDelegate:nil];
  [self setQueryResults:nil];
}

- (void)queryUpdated:(NSNotification *)note {
  [self setQueryResults:[query results]];
  
  for (NSMetadataItem *item in self.queryResults) {
      id filePath = [item valueForKey:(NSString *)kMDItemPath];
      NSLog(@"Found screenshot: %@",filePath);
    if ([[BSDataStore sharedInstance] autoUpdateScreenShots]) {
      [[BSUploadManager sharedInstance] uploadFile:filePath];
    }
  }
}


- (void)uploadFromService:(NSPasteboard *)pboard
             userData:(NSString *)userData
                    error:(NSString **)error {
  if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
    NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
    for (NSString *fileName in files) {
      [[BSUploadManager sharedInstance] uploadFile:fileName];
    }
  }
}

@end
