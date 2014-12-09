//
//  AppDelegate.m
//  WaterMarker
//
//  Created by Iain Wood on 25/11/2014.
//  Copyright (c) 2014 soulflyer. All rights reserved.
//

#import "AppDelegate.h"
#import "IWView.h"
@class IWApertureAccess;

@interface IWApertureAccess : NSObject
-(NSString *) getLibrary;
-(NSString *) getDatabase;
-(NSArray *) getSelectedPhotos;
-(NSString *) writeIPTC:(NSString*)iptcData toField:(NSString*)iptcField ofPic:(NSString*)thePic ofProject:(NSString*)theProject ofMonth:(NSString*)theMonth ofYear:(NSString*)theYear;
-(NSString *) getPreviewOf:(NSString*)thePic ofProject:(NSString*)theProject ofMonth:(NSString*)theMonth ofYear:(NSString*)theYear;
@end

@interface AppDelegate ()
//@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (NSImage *)getPreviewImageOfPic:(NSDictionary*)image {
  NSString *name    = [image objectForKey:@"name"];
  NSString *year    = [image objectForKey:@"year"];
  NSString *month   = [image objectForKey:@"month"];
  NSString *project = [image objectForKey:@"project"];
  NSString *imagePath = [Aperture getPreviewOf:name ofProject:project ofMonth:month ofYear:year];
  return [[NSImage alloc] initWithContentsOfFile:imagePath];
}

- (NSString *)getWatermark:(NSDictionary*)image {
  if ([image objectForKey:@"watermark"]) {
    return [image objectForKey:@"watermark"];
  }
  return @"BL12S10X2Y2";
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
  Aperture = [[NSClassFromString(@"IWApertureAccess") alloc] init];
  //NSString *dataBasePath = [Aperture getDatabase];
  //NSLog(@"%@",dataBasePath);
  
  //[theView setWatermarkFile:[NSURL URLWithString:@"/Users/iain/Pictures/Watermarks/Soulflyer2000.png"]];
  [theView setWatermarkImage:[[NSImage alloc] initWithContentsOfFile:@"/Users/iain/Pictures/Watermarks/Soulflyer2000.png"]];
  
  selectedImages=[Aperture getSelectedPhotos];
  NSImage *theImage = [self getPreviewImageOfPic:selectedImages[0]];
  [theView setImage:theImage];
  [theView initWatermarkValues:[self getWatermark:selectedImages[0]]];
  NSLog(@"Watermark (from image): %@",[self getWatermark:selectedImages[0]]);
  NSLog(@"Watermark (from view): %@",[theView watermarkValues]);

  
  //IWWriteIPTC *IWWriteIPTCInstance = [[NSClassFromString(@"IWWriteIPTC") alloc] init ];
  
  //NSString *result=[Aperture writeIPTC:@"BL66S15X1Y2" toField:@"SpecialInstructions" ofPic:firstname ofProject:firstProject ofMonth:firstMonth ofYear:firstYear];
  //NSLog(@"%@",result);
  
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (IBAction)previousImage:(id)sender {
  NSLog(@"previousImage button pressed");
  if (imageIndex > 0){
    imageIndex -= 1;
    NSLog(@"Watermark: %@",[self getWatermark:selectedImages[imageIndex]]);
    NSImage *theImage = [self getPreviewImageOfPic:selectedImages[imageIndex]];
    [theView setImage:theImage];
    [theView initWatermarkValues:[self getWatermark:selectedImages[imageIndex]]];
    [theView setNeedsDisplay:true];
  }
}
- (IBAction)nextImage:(id)sender {
  NSLog(@"nextImage button pressed");
  if (imageIndex < selectedImages.count - 1){
    imageIndex += 1;
    NSImage *theImage = [self getPreviewImageOfPic:selectedImages[imageIndex]];
    [theView setImage:theImage];
    [theView initWatermarkValues:[self getWatermark:selectedImages[imageIndex]]];
    [theView setNeedsDisplay:true];
  }
}

-(IBAction)setBottom:(id)sender{
  [theView setBottom:YES];
}

-(IBAction)setTop:(id)sender{
  [theView setBottom:NO];
}

-(IBAction)setRight:(id)sender{
  [theView setRight:YES];
}

-(IBAction)setLeft:(id)sender{
  [theView setRight:NO];
}

-(void)incY{
  if([theView yOffsetPercent]<50){
    [theView setYOffsetPercent:[theView yOffsetPercent]+1];
  }
}


-(void)decY{
  if([theView yOffsetPercent]>0){
    [theView setYOffsetPercent:[theView yOffsetPercent]-1];
  }
  
}

-(void)decX{
  if([theView xOffsetPercent]>0){
    [theView setXOffsetPercent:[theView xOffsetPercent]-1];
  }
}

-(void)incX{
  if([theView xOffsetPercent]<50){
    [theView setXOffsetPercent:[theView xOffsetPercent]+1];
  }
}

-(IBAction)moveLeft:(id)sender{
  if([theView right]){
    [self incX];
  }else{
    [self decX];
  }
}

-(IBAction)moveRight:(id)sender{
  if([theView right]){
    [self decX];
  }else{
    [self incX];
  }
}

-(IBAction)moveUp:(id)sender{
  if([theView bottom]){
    [self incY];
  }else{
    [self decY];
  }
}

-(IBAction)moveDown:(id)sender{
  if([theView bottom]){
    [self decY];
  }else{
    [self incY];
  }
}

-(IBAction)incOpacity:(id)sender{
  if([theView opacityPercent]<100){
    [theView setOpacityPercent:[theView opacityPercent]+1];
  }
}

-(IBAction)decOpacity:(id)sender{
  if([theView opacityPercent]>0){
    [theView setOpacityPercent:[theView opacityPercent]-1];
  }
}

-(IBAction)incSize:(id)sender{
  if([theView widthPercent]<50){
    [theView setWidthPercent:[theView widthPercent]+1];
  }
}

-(IBAction)decSize:(id)sender{
  if([theView widthPercent]>5){
    [theView setWidthPercent:[theView widthPercent]-1];
  }
}

-(IBAction)toggleVisibility:(id)sender{
  if([theView toolsVisible]){
    [theView setToolsVisible:NO];
  }else{
    [theView setToolsVisible:YES];
  }
}
@end
