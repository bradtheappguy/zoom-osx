//
//  BSMenuet.m
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import "BSMenuet.h"
#import "DragStatusView.h"

@implementation BSMenuet

- (void)awakeFromNib
{
  _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  [_statusItem setHighlightMode:YES];
  [_statusItem setTitle:@"0.0.0.0"];
  [_statusItem setEnabled:YES];
  [_statusItem setToolTip:@"IPMenulet"];
  [_statusItem setImage:[NSImage imageNamed:@"icon_menulet"]];
  [_statusItem setAction:@selector(statusItemWasClicked:)];
  [_statusItem setTarget:self];
  DragStatusView* dragView = [[DragStatusView alloc] initWithFrame:NSMakeRect(0, 0, 24, 24)];
  [_statusItem setView:dragView];
}

-(IBAction)statusItemWasClicked:(id)sender
{

}

@end
