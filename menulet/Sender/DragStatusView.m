//
//  DragStatusView.m
//  Sender
//
//  Created by Brad Smith on 11/27/13.
//  Copyright (c) 2013 Brad Smith Inc. All rights reserved.
//

#import "DragStatusView.h"
#import "BSUploadManager.h"


@implementation DragStatusView

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self registerForDraggedTypes:[NSArray arrayWithObjects: NSFilenamesPboardType, nil]];
    _image = [NSImage imageNamed:@"icon_menulet"];
  }
  return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
  [_image drawInRect:dirtyRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
}


//we want to copy the files
- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
  _image = [NSImage imageNamed:@"icon_menulet_blue"];
  [self setNeedsDisplay:YES];
  return NSDragOperationCopy;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender {
  _image = [NSImage imageNamed:@"icon_menulet"];
  [self setNeedsDisplay:YES];
}


//perform the drag and log the files that are dropped
- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
  NSPasteboard *pboard;
  NSDragOperation sourceDragMask;
  
  sourceDragMask = [sender draggingSourceOperationMask];
  pboard = [sender draggingPasteboard];
  
  if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
    NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
    for (NSString *fileName in files) {
      [[BSUploadManager sharedInstance] uploadFile:fileName];
    }
  }
  return YES;
}

- (void)mouseDown:(NSEvent *)event {
  NSLog(@"down");
  [self.statusItem popUpStatusItemMenu:self.statusItem.menu];
  NSLog(@"down2");
}


@end
