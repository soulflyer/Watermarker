//
//  IWDuplicateView.m
//  WaterMarker
//
//  Created by Iain Wood on 17/04/2015.
//  Copyright (c) 2015 soulflyer. All rights reserved.
//

#import "IWDuplicateView.h"

@implementation IWDuplicateView

- (void)drawRect:(NSRect)dirtyRect {
    //[super drawRect:dirtyRect];
  if(image){
    NSRect imageRect;
    imageRect.origin=NSZeroPoint;
    imageRect.size=[image size];
    NSRect drawInRect = imageRect;
    drawInRect.size.width = 500;
    drawInRect.size.height = 500 * imageRect.size.height / imageRect.size.width;
    [image drawInRect:drawInRect
             fromRect:imageRect
            operation:NSCompositeSourceOver
             fraction:1];
  }
}

- (NSImage *)image{
  return image;
}

-(void)setImage:(NSImage *)newImage{
  image=newImage;
  [self setNeedsDisplay:true];
}

@end
