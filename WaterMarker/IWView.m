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
    NSRect theWindowContentRect = [[self window] contentRectForFrameRect:theWindowRect];
    theWindowContentRect.size.height = theWindowContentRect.size.width * image.size.height / image.size.width;
    [[self window] setContentSize:theWindowContentRect.size];
    
    theWindowRect = [[self window] frame];
    if(theWindowRect.size.height > visibleScreen.size.height){
      theWindowRect.size.height=visibleScreen.size.height;
      theWindowRect.size.width=theWindowRect.size.height * image.size.width / image.size.height;
    }
    if(theWindowRect.size.width > visibleScreen.size.width){
      theWindowRect.size.width = visibleScreen.size.width;
      theWindowRect.size.height = theWindowRect.size.width * image.size.height / image.size.width;
    }
    
    [[self window] setFrame:theWindowRect display:false];
    theWindowContentRect = [[self window] contentRectForFrameRect:theWindowRect];
    
    //Set the view to match the available space
    NSRect theViewRect = theWindowContentRect;
    theViewRect.origin = NSZeroPoint;
    [self setFrame:theViewRect];
    
    //Draw the image to the view
    NSRect imageRect;
    imageRect.origin=NSZeroPoint;
    imageRect.size = [self frame].size;
    [image drawInRect:imageRect];
    
    //Draw the watermark over the image
    if([self watermarkImage]) {
      NSRect imageRect;
      imageRect.origin=NSZeroPoint;
      if([self right]){
        imageRect.origin.x=[self frame].size.width*(1-([self xOffsetPercent]+[self widthPercent])/100.0);
      }else{
        imageRect.origin.x=[self frame].size.width * [self xOffsetPercent]/100.0;
      }
      if([self bottom]){
        imageRect.origin.y=[self frame].size.height * [self yOffsetPercent] / 100.0;
      }else{
        imageRect.origin.y=[self frame].size.height*(1-([self yOffsetPercent])/100.0)-[self frame].size.width*([self watermarkImage].size.height/[self watermarkImage].size.width)*[self widthPercent]/100.0;
      }
      imageRect.size.width=[self frame].size.width * [self widthPercent] / 100.0;
      imageRect.size.height=imageRect.size.width * [self watermarkImage].size.height / [self watermarkImage ].size.width;
      NSRect drawingRect=imageRect;
      [[self watermarkImage] drawInRect:drawingRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:[self opacityPercent]/100.0];
    }
  }
}

-(NSImage *)image{
  return image;
}

-(void)setImage:(NSImage *)newImage{
  image=newImage;
  [self setNeedsDisplay:YES];
}

-(void)setWatermarkValues:(NSString*)watermarkString{
  if([watermarkString isEqualTo:@""]){
    watermarkString=@"BL12S10X1Y1";
  }
  NSString* topBottom = [watermarkString substringToIndex:1];
  [self setBottom:true];
  if([topBottom isEqual:@"T"] || [topBottom isEqual:@"t"]){
    [self setBottom:false];
  }
  NSLog(@"%@",topBottom);
  NSLog(@"%i",[self bottom]);
  
  NSRange range = {1,1};
  NSString* leftRight = [watermarkString substringWithRange:range];
  [self setRight:true];
  if ([leftRight isEqual:@"l"] || [leftRight isEqual:@"L"]){
    [self setRight:false];
  }
  NSLog(@"%@",leftRight);
  NSLog(@"%i",[self right]);
  NSString* watermarkNumbers = [watermarkString substringFromIndex:2];
  NSLog(@"%@",watermarkNumbers);
  NSArray *watermarkNumbersArray=[watermarkNumbers componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"SsXxYx"]];
  [self setOpacityPercent:[watermarkNumbersArray[0] intValue]];
  [self setWidthPercent:[watermarkNumbersArray[1] intValue]];
  [self setXOffsetPercent:[watermarkNumbersArray[2] intValue]];
  [self setYOffsetPercent:[watermarkNumbersArray[3] intValue]];
}

-(NSString*)watermarkValues{
  NSString* upDown;
  NSString* leftRight;
  if([self bottom]){
    upDown=@"B";
  }else{
    upDown=@"T";
  }
  if([self right ]){
    leftRight=@"R";
  }else{
    leftRight=@"L";
  }
  return [NSString stringWithFormat:@"%@%@%dS%dX%dY%d",upDown,leftRight,[self opacityPercent ],[self widthPercent ],[self xOffsetPercent ],[self yOffsetPercent ]];
}

@end
