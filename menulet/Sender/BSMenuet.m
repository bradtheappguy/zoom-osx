//
//  BSMenuet.m
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import "BSMenuet.h"
#import "DragStatusView.h"
#import "BSUploadManager.h"
#import "BSDataStore.h"
#import "BSUploadedFile.h"
#import "BSCompletedStatusWindow.h"
#import "BSPrefrencesPanel.h"

@implementation BSMenuet

- (void)awakeFromNib
{
  _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
  [_statusItem setHighlightMode:NO];
  [_statusItem setTitle:@""];
  [_statusItem setEnabled:YES];
  [_statusItem setToolTip:@"IPMenulet"];
  [_statusItem setTarget:self];
  DragStatusView* dragView = [[DragStatusView alloc] initWithFrame:NSMakeRect(0, 0, 30, 22)];
  [dragView setStatusItem:_statusItem];
  [_statusItem setView:dragView]; 
  
  [self updateMenu];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMenu) name:@"UPDATED_FILES" object:nil];
}

-(void) updateMenu {
  NSLog(@"update");
  NSMenu *customMenu = [_statusItem menu];
  if (!customMenu) {
    customMenu = [[NSMenu alloc] init];
  }
  [customMenu setAutoenablesItems:NO];
  
  [customMenu removeAllItems];
  
  NSMenuItem *item1 = [customMenu insertItemWithTitle:NSLocalizedString(@"Upload File...", @"Select File - Menu Item") action:@selector(selectFile:) keyEquivalent:@"" atIndex:0];
  [item1 setTarget:self];
  
  [customMenu insertItem:[NSMenuItem separatorItem] atIndex:1];
  
  NSMenuItem *item3 = [customMenu insertItemWithTitle:NSLocalizedString(@"Recent Uploads", @"Select File - Menu Item") action:@selector(selectFile:) keyEquivalent:@"" atIndex:2];
  
  [item3 setTarget:self];
  
  NSArray *recentlyUploadedIteme = [[BSDataStore sharedInstance] recentlyUploadedFiles];
  
  _menuToFileMapping = [[NSMutableDictionary alloc] init];
  int index = 0;
  for (BSUploadedFile *file in recentlyUploadedIteme) {
    NSMenuItem *item = [customMenu insertItemWithTitle:[file fileName] action:nil keyEquivalent:@"" atIndex:[customMenu.itemArray count]];
    
    NSMenu *subMenu = [[NSMenu alloc] init];
    
    [_menuToFileMapping setValue:file forKey:[NSString stringWithFormat:@"%d",index]];
    
    [subMenu setAutoenablesItems:NO];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMM dd, 2013"];
    NSString *uplodedDate = [df stringFromDate:file.createdAt];
    [df setDateFormat:@"hh:mm aaa"];
    NSString *uplodedTime = [df stringFromDate:file.createdAt];
    
    
    
    NSString *uploadedOnString = [NSString stringWithFormat:@"Uploaded %@ at %@",uplodedDate,uplodedTime];
    NSMenuItem *sub = [subMenu insertItemWithTitle:uploadedOnString action:nil keyEquivalent:@"" atIndex:[subMenu.itemArray count]];
    [sub setTag:index];
    [sub setTarget:self];
    [sub setEnabled:NO];
    [item setSubmenu:subMenu];
 
    [subMenu insertItem:[NSMenuItem separatorItem] atIndex:[subMenu.itemArray count]];
  
    NSMenuItem *sub1 = [subMenu insertItemWithTitle:@"Copy link to Clipboard" action:@selector(copyLink:) keyEquivalent:@"" atIndex:[subMenu.itemArray count]];
    [sub1 setTarget:self];
    [sub1 setTag:index];
    
    NSMenuItem *sub2 = [subMenu insertItemWithTitle:@"View in Browser" action:@selector(openPage:)  keyEquivalent:@"" atIndex:[subMenu.itemArray count]];
    [sub2 setTarget:self];
    [sub2 setTag:index];
    
    NSError *error = nil;
    [file.originalFile checkResourceIsReachableAndReturnError:&error];
    if (!error) {
      NSMenuItem *sub3 = [subMenu insertItemWithTitle:@"Reveal original file" action:@selector(revealOriginal:) keyEquivalent:@"" atIndex:[subMenu.itemArray count]];
      [sub3 setTarget:self];
      [sub3 setTag:index];
    }

    

    
    NSMenuItem *sub4 = [subMenu insertItemWithTitle:@"Delete" action:@selector(deleteFile:) keyEquivalent:@"" atIndex:[subMenu.itemArray count]];
    [sub4 setTarget:self];
    [sub4 setTag:index];
    
    index++;
  }
  
  
  [customMenu insertItem:[NSMenuItem separatorItem] atIndex:[customMenu.itemArray count]];

  NSMenuItem *item4= [customMenu insertItemWithTitle:NSLocalizedString(@"Autoupload Screenshots", @"Autoupload Screenshots - Menu Item") action:@selector(toggleScreenshots:) keyEquivalent:@"" atIndex:[customMenu.itemArray count]];
  [item4 setTarget:self];
  if ([[BSDataStore sharedInstance] autoUpdateScreenShots]) {
    [item4 setState:NSOnState];
  }
  else {
    [item4 setState:NSOffState];
  }
  
  [customMenu insertItem:[NSMenuItem separatorItem] atIndex:[customMenu.itemArray count]];
  
  NSMenuItem *item5 = [customMenu insertItemWithTitle:NSLocalizedString(@"Preferences...", @"Preferences... - Menu Item") action:@selector(showPrefs:) keyEquivalent:@"" atIndex:[customMenu.itemArray count]];
  [item5 setTarget:self];
  [_statusItem setMenu:customMenu];
  
  NSMenuItem *item2 = [customMenu insertItemWithTitle:NSLocalizedString(@"Quit", @"Quit - Menu Item") action:@selector(quit:) keyEquivalent:@"" atIndex:[customMenu.itemArray count]];
  [item2 setTarget:self];
  [_statusItem setMenu:customMenu];
  
  [item3 setEnabled:NO];
}


-(void)selectFile:(id)sender {
  NSOpenPanel *panel = [NSOpenPanel openPanel];
  [panel setCanChooseFiles:YES];
  [panel setCanChooseDirectories:NO];
  [panel setAllowsMultipleSelection:NO]; // yes if more than one dir is allowed
  
  NSInteger clicked = [panel runModal];
  
  if (clicked == NSFileHandlingPanelOKButton) {
    for (NSURL *url in [panel URLs]) {
      [[BSUploadManager sharedInstance] uploadFileURL:url];
    }
  }
}

-(void)quit:(id)sender {
  [NSApp terminate:self];
}

-(void)copyLink:(id)sender {
  NSString *key = [NSString stringWithFormat:@"%ld",[sender tag]];
  BSUploadedFile *file = [_menuToFileMapping objectForKey:key];
  
  [[NSPasteboard generalPasteboard] clearContents];
  [[NSPasteboard generalPasteboard] setString:[file page]  forType:NSStringPboardType];
  
  [[BSCompletedStatusWindow sharedInstance] displayMessage:NSLocalizedString(@"Copied", @"") WithFileName:[file page] duration:2.0];
}

-(void)openPage:(id)sender {
  NSString *key = [NSString stringWithFormat:@"%ld",[sender tag]];
  BSUploadedFile *file = [_menuToFileMapping objectForKey:key];
  NSURL *url = [NSURL URLWithString:file.page];
  
  [[NSWorkspace sharedWorkspace] openURL:url];
}

-(void)revealOriginal:(id)sender {
  NSString *key = [NSString stringWithFormat:@"%ld",[sender tag]];
  BSUploadedFile *file = [_menuToFileMapping objectForKey:key];
  [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[file.originalFile]];
}

-(void)deleteFile:(id)sender {
  NSString *key = [NSString stringWithFormat:@"%ld",[sender tag]];
  BSUploadedFile *file = [_menuToFileMapping objectForKey:key];
  [[BSUploadManager sharedInstance] deleteFile:file];
}

-(void) toggleScreenshots:(NSMenuItem *)sender {
  if ([sender state] != NSOnState) {
    [sender setState:NSOnState];
    [[BSDataStore sharedInstance] setAutoUpdateScreenShots:YES];
  }
  else {
    [sender setState:NSOffState];
    
    [[BSDataStore sharedInstance] setAutoUpdateScreenShots:NO];
  }
  
}

-(void) showPrefs:(id)sender {
  BSPrefrencesPanel *panel = [BSPrefrencesPanel sharedInstance];

  [NSApp activateIgnoringOtherApps:YES];
  [panel center];
  [panel makeKeyAndOrderFront:self];
  [panel setIsVisible:YES];
  [panel update];
  
  NSLog(@"x");
}
@end
