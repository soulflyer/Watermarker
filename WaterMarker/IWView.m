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
    theWindowRect = [[self window] frameRectForContentRect:theWindowContentRect];
    if(theWindowRect.size.height > visibleScreen.size.height){
      theWindowRect.size.height=visibleScreen.size.height - 10;
      theWindowRect.size.width=theWindowRect.size.height * image.size.width / image.size.height;
    }
    if(theWindowRect.size.width > visibleScreen.size.width){
      theWindowRect.size.width = visibleScreen.size.width - 20;
      theWindowRect.size.height = theWindowRect.size.width * image.size.height / image.size.width;
    }
    
    theWindowContentRect = [[self window] contentRectForFrameRect:theWindowRect];
    theWindowRect.origin.x = 10;
    theWindowRect.origin.y = 10;
    [[self window] setContentSize:theWindowContentRect.size];
    [[self window] setFrameOrigin:theWindowRect.origin];
    
    //Set the view to match the available space
    NSRect theViewRect = theWindowContentRect;
    theViewRect.origin = NSZeroPoint;
    [self setFrame:theViewRect];
    
    //Draw the image to the view
    [image drawInRect:theViewRect];
    
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

-(void)initWatermarkValues:(NSString*)watermarkString{
  if([watermarkString isEqualTo:@""]){
    // Provide a default string if param is the empty string
    //watermarkString=@"BL20S15X1Y1";
    // Or use the previous values
    watermarkString=[self watermarkValues];
    if ([watermarkString isEqualTo:@"TL0S0X0Y0"]) {
      watermarkString = @"BL20S15X1Y1";
    }
  }
  NSString* topBottom = [watermarkString substringToIndex:1];
  [self setBottom:true];
  if([topBottom isEqual:@"T"] || [topBottom isEqual:@"t"]){
    [self setBottom:false];
  }
  
  NSRange range = {1,1};
  NSString* leftRight = [watermarkString substringWithRange:range];
  [self setRight:true];
  if ([leftRight isEqual:@"l"] || [leftRight isEqual:@"L"]){
    [self setRight:false];
  }

  NSString* watermarkNumbers = [watermarkString substringFromIndex:2];
  NSArray *watermarkNumbersArray=[watermarkNumbers componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"SsXxYx"]];
  [self setOpacityPercent:[watermarkNumbersArray[0] intValue]];
  [self setWidthPercent:[watermarkNumbersArray[1] intValue]];
  [self setXOffsetPercent:[watermarkNumbersArray[2] intValue]];
  [self setYOffsetPercent:[watermarkNumbersArray[3] intValue]];
}

-(NSString*)watermarkValues{
  NSString* upDown;
  NSString* leftRight;
  if(bottom){
    upDown=@"B";
  }else{
    upDown=@"T";
  }
  if(right){
    leftRight=@"R";
  }else{
    leftRight=@"L";
  }
  return [NSString stringWithFormat:@"%@%@%dS%dX%dY%d",upDown,leftRight,opacityPercent,widthPercent,xOffsetPercent,yOffsetPercent];
}

-(void)setWatermarkValues:(NSString *)dummy{
  
}


-(int)opacityPercent{
  return opacityPercent;
}

-(void)setOpacityPercent:(int)newOpacityPercent{
  opacityPercent=newOpacityPercent;
  [self setWatermarkValues:@""];
  [self setNeedsDisplay:YES];
}


-(int)widthPercent{
  return widthPercent;
}

-(void)setWidthPercent:(int)newWidthPercent{
  widthPercent=newWidthPercent;
  [self setWatermarkValues:@""];
  [self setNeedsDisplay:YES];
}

-(int)xOffsetPercent{
  return xOffsetPercent;
}

-(void)setXOffsetPercent:(int)newXOffsetPercent{
  xOffsetPercent=newXOffsetPercent;
  [self setWatermarkValues:@""];
  [self setNeedsDisplay:YES];
}

-(int)yOffsetPercent{
  return yOffsetPercent;
}

-(void)setYOffsetPercent:(int)newYOffsetPercent{
  yOffsetPercent=newYOffsetPercent;
  [self setWatermarkValues:@""];
  [self setNeedsDisplay:YES];
}


-(Boolean)bottom{
  return bottom;
}

-(void)setBottom:(Boolean)newBottom{
  bottom=newBottom;
  [self setWatermarkValues:@""];
  [self setNeedsDisplay:YES];
}

-(Boolean)right{
  return right;
}

-(void)setRight:(Boolean)newRight{
  right=newRight;
  [self setWatermarkValues:@""];
  [self setNeedsDisplay:YES];
}


@end
