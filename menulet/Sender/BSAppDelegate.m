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
#import <CrashReporter/CrashReporter.h>

@implementation BSAppDelegate



//
// Called to handle a pending crash report.
//
- (void) handleCrashReport {
  PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
  NSData *crashData;
  NSError *error;
  
  // Try loading the crash report
  crashData = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
  if (crashData == nil) {
    NSLog(@"Could not load crash report: %@", error);
    [crashReporter purgePendingCrashReport];
  }
  
  // We could send the report from here, but we'll just print out
  // some debugging info instead
  PLCrashReport *report = [[PLCrashReport alloc] initWithData: crashData error: &error];
  if (report == nil) {
    NSLog(@"Could not parse crash report");
    [crashReporter purgePendingCrashReport];
  }
  
  NSLog(@"Crashed on %@", report.systemInfo.timestamp);
  NSLog(@"Crashed with signal %@ (code %@, address=0x%" PRIx64 ")", report.signalInfo.name,
        report.signalInfo.code, report.signalInfo.address);
  

  [crashReporter purgePendingCrashReport];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  
  [NSApp setServicesProvider:self];
  
  PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
  //NSError *error;
  
  // Check if we previously crashed
  if ([crashReporter hasPendingCrashReport]) {
    [self handleCrashReport];
  }
  
  // Enable the Crash Reporter
 // if (![crashReporter enableCrashReporterAndReturnError: &error])
   // NSLog(@"Warning: Could not enable crash reporter: %@", error);
  
  
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
