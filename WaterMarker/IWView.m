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
    NSRect visibleScreen = [[NSScreen mainScreen] visibleFrame];
   
    //Set the window to the right proportions
    NSRect theWindowRect = [[self window] frame];
    //theWindowRect.size.width = theWindowRect.size.height * image.size.width / image.size.height;
    theWindowRect.size.height = theWindowRect.size.width * image.size.height / image.size.width;
    if(theWindowRect.size.height > visibleScreen.size.height){
      theWindowRect.size.height=visibleScreen.size.height;
      theWindowRect.size.width=theWindowRect.size.height * image.size.width / image.size.height;
    }
    if(theWindowRect.size.width > visibleScreen.size.width){
      theWindowRect.size.width = visibleScreen.size.width;
      theWindowRect.size.height = theWindowRect.size.width * image.size.height / image.size.width;
    }
    
    [[self window] setContentSize:theWindowRect.size];

    //Set the view to match the available space
    NSRect theViewRect = theWindowRect;
    theViewRect.origin = NSZeroPoint;
    [self setFrame:theViewRect];
    
    //Draw the image to the view
    NSRect imageRect;
    imageRect.origin=NSZeroPoint;
    imageRect.size = [self frame].size;
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
