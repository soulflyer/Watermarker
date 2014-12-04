//
//  IWView.m
//  WaterMarker
//
//  Created by Iain Wood on 01/12/2014.
//  Copyright (c) 2014 soulflyer. All rights reserved.
//

#import "IWView.h"

@implementation IWView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
  [[NSColor redColor] set];
  NSRectFill([self frame]);
  if(image){
    [[NSColor blueColor] set];
    NSRectFill([self frame]);
    NSRect imageRect = [self frame];
    [image drawInRect:imageRect];
  }
}

-(NSImage *)image{
  return image;
}

-(void)setImage:(NSImage *)newImage{
  image=newImage;
  [self setNeedsDisplay:YES];
}

@end
