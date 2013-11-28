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

@implementation BSMenuet

- (void)awakeFromNib
{
  _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  [_statusItem setHighlightMode:NO];
  [_statusItem setTitle:@""];
  [_statusItem setEnabled:YES];
  [_statusItem setToolTip:@"IPMenulet"];
  [_statusItem setImage:[NSImage imageNamed:@"icon_menulet"]];
  [_statusItem setTarget:self];
  DragStatusView* dragView = [[DragStatusView alloc] initWithFrame:NSMakeRect(0, 0, 24, 24)];
  [dragView setStatusItem:_statusItem];
  //[_statusItem setView:dragView];
  
  NSMenu *customMenu = [[NSMenu alloc] init];
  
  NSMenuItem *item1 = [customMenu insertItemWithTitle:NSLocalizedString(@"Select File...", @"Select File - Menu Item") action:@selector(selectFile:) keyEquivalent:@"" atIndex:0];
  [item1 setTarget:self];
  
  [customMenu insertItem:[NSMenuItem separatorItem] atIndex:1];
  
  
  NSMenuItem *item2 = [customMenu insertItemWithTitle:NSLocalizedString(@"Quit", @"Quit - Menu Item") action:@selector(quit:) keyEquivalent:@"" atIndex:2];
  [item2 setTarget:self];
  [_statusItem setMenu:customMenu];
  

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
