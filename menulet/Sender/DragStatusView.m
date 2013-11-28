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
  }
  return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
  NSImage *image = [NSImage imageNamed:@"icon_menulet"];
  [image drawInRect:dirtyRect];
}


//we want to copy the files
- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
  return NSDragOperationCopy;
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


@end
