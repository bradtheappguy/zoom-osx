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

@implementation BSMenuet

- (void)awakeFromNib
{
  _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  [_statusItem setHighlightMode:NO];
  [_statusItem setTitle:@""];
  [_statusItem setEnabled:YES];
  [_statusItem setToolTip:@"IPMenulet"];
  [_statusItem setTarget:self];
  DragStatusView* dragView = [[DragStatusView alloc] initWithFrame:NSMakeRect(0, 0, 24, 24)];
  [dragView setStatusItem:_statusItem];
  [_statusItem setView:dragView];
  
  [self updateMenu];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMenu) name:@"UPDATED_FILES" object:nil];
}

-(void) updateMenu {
  NSMenu *customMenu = [[NSMenu alloc] init];
  [customMenu setAutoenablesItems:NO];
  
  NSMenuItem *item1 = [customMenu insertItemWithTitle:NSLocalizedString(@"Select File...", @"Select File - Menu Item") action:@selector(selectFile:) keyEquivalent:@"" atIndex:0];
  [item1 setTarget:self];
  
  [customMenu insertItem:[NSMenuItem separatorItem] atIndex:1];
  
  NSMenuItem *item3 = [customMenu insertItemWithTitle:NSLocalizedString(@"Recent Uploads", @"Select File - Menu Item") action:@selector(selectFile:) keyEquivalent:@"" atIndex:2];
  
  [item3 setTarget:self];
  
  NSArray *recentlyUploadedIteme = [[BSDataStore sharedInstance] recentlyUploadedFiles];
  for (BSUploadedFile *file in recentlyUploadedIteme) {
    NSMenuItem *item = [customMenu insertItemWithTitle:[file page] action:nil keyEquivalent:@"" atIndex:[customMenu.itemArray count]];
    [item setTarget:self];
  }
  
  
  [customMenu insertItem:[NSMenuItem separatorItem] atIndex:[customMenu.itemArray count]];
  
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

@end
