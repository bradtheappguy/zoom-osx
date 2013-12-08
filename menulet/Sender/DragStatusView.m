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
    _image = [NSImage imageNamed:@"plane"];
    
    [[BSUploadManager sharedInstance] addObserver:self forKeyPath:@"percentUploaded" options:0 context:0];
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
  _image = [NSImage imageNamed:@"plane-rollover"];
  [self setNeedsDisplay:YES];
  return NSDragOperationCopy;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender {
  _image = [NSImage imageNamed:@"plane"];
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:@"percentUploaded"]) {
    CGFloat percent = [[BSUploadManager sharedInstance] percentUploaded];
    int index = percent*100 / 5;
    NSString *imageName = [NSString stringWithFormat:@"plane-uploading%d",index];
    NSLog(@"XXX: %f %d %@",percent,index, imageName);
    _image = [NSImage imageNamed:imageName];
    [self setNeedsDisplay:YES];
    
    if (percent >= 1.0) {
      _image = [NSImage imageNamed:@"plane-done"];
      [self setNeedsDisplay:YES];
      double delayInSeconds = 2.0;
      dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
      dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([[BSUploadManager sharedInstance] percentUploaded] >= 1.0) {
          _image = [NSImage imageNamed:@"plane"];
          [self setNeedsDisplay:YES];
        }
        
      });
    }
  }
}
@end
