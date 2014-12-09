//
//  IWView.h
//  WaterMarker
//
//  Created by Iain Wood on 01/12/2014.
//  Copyright (c) 2014 soulflyer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IWView : NSView{
  NSImage *image;
  Boolean bottom;
  Boolean right;
  int opacityPercent;
  int widthPercent;
  int xOffsetPercent;
  int yOffsetPercent;
}
-(void)initWatermarkValues:(NSString*) watermarkString;
@property (strong) NSString *watermarkValues;
@property (strong) NSImage *image;
//@property (strong) NSString *code;
@property (assign) int corner;
@property (assign) Boolean bottom;
@property (assign) Boolean right;
@property (assign) Boolean visible;
@property (assign) int xOffsetPercent;
@property (assign) int yOffsetPercent;
@property (assign) int widthPercent;
@property (assign) int opacityPercent;
@property (assign) float opacity;
@property (strong) NSImage *watermarkImage;
@property (strong) NSURL *watermarkFile;
@property (assign) Boolean toolsVisible;
@end
