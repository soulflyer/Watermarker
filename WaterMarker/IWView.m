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
    NSRect theWindowRect = [[self window] frame];
    //theWindowRect.size.width = theWindowRect.size.height * image.size.width / image.size.height;
    theWindowRect.size.height = theWindowRect.size.width * image.size.height / image.size.width;
    NSRect theViewRect = theWindowRect;
    theViewRect.origin = NSZeroPoint;
    [self setFrame:theViewRect];
    //[[self window] setFrame:theWindowRect display:true];
    //[[self window] setContentSize:image.size];
    [[self window] setContentSize:theWindowRect.size];
    
    NSRect imageRect;
    imageRect.origin=NSZeroPoint;
    imageRect.size.width=[self frame].size.width;
    //imageRect.size.height=imageRect.size.width * image.size.height / image.size.width;
    imageRect.size.height=[self frame].size.height;
    //NSSize imageRectSize = [image size];
    //NSRect theWindowRect = [[self window] frame];
    //theWindowRect.size.width = image.size.width;
    //theWindowRect.size.height = image.size.height;
    
    //[[self window] setFrame:theWindowRect display:true];
    //[self setFrame:theWindowRect];
    //NSRect theRect = [self frame];
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
