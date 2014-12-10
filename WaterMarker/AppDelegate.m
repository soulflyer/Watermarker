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
  NSArray  *previewArray = [imagePath componentsSeparatedByString:@"\r"];
  NSLog(@"[previewArray count]: %lu",(unsigned long)[previewArray count]);
  if ([previewArray count] > 1){
    NSLog(@"In getPreviewImageOfPic: %@",imagePath);
    NSDictionary *info = [NSDictionary dictionaryWithObject:@"Found multiple preview images, try changing the version name of one of the images in Aperture.\n\n Click ok to view the first preview pic found." forKey:NSLocalizedRecoverySuggestionErrorKey];
    NSError *error = [NSError errorWithDomain:@"Find Previews" code:1 userInfo:info];
    NSAlert *alert = [NSAlert alertWithError:error];
    [alert runModal];
    imagePath = previewArray[0];
  }
  return [[NSImage alloc] initWithContentsOfFile:imagePath];
}

- (NSString *)getWatermark:(NSDictionary*)image {
  if ([image objectForKey:@"watermark"]) {
    return [image objectForKey:@"watermark"];
  }
  return @"BL12S10X2Y2";
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  Aperture = [[NSClassFromString(@"IWApertureAccess") alloc] init];
  //NSString *dataBasePath = [Aperture getDatabase];
  
  [theView setWatermarkImage:[[NSImage alloc] initWithContentsOfFile:@"/Users/iain/Pictures/Watermarks/Soulflyer2000.png"]];
  
  selectedImages=[Aperture getSelectedPhotos];
  NSImage *theImage = [self getPreviewImageOfPic:selectedImages[0]];
  [theView setImage:theImage];
  [theView initWatermarkValues:[self getWatermark:selectedImages[0]]];
  
  //IWWriteIPTC *IWWriteIPTCInstance = [[NSClassFromString(@"IWWriteIPTC") alloc] init ];
  
  //NSString *result=[Aperture writeIPTC:@"BL66S15X1Y2" toField:@"SpecialInstructions" ofPic:firstname ofProject:firstProject ofMonth:firstMonth ofYear:firstYear];
  //NSLog(@"%@",result);
  
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (IBAction)previousImage:(id)sender {
  if (imageIndex > 0){
    imageIndex -= 1;
    NSImage *theImage = [self getPreviewImageOfPic:selectedImages[imageIndex]];
    [theView setImage:theImage];
    [theView initWatermarkValues:[self getWatermark:selectedImages[imageIndex]]];
    [theView setNeedsDisplay:true];
  }
}

- (IBAction)nextImage:(id)sender {
  if (imageIndex < selectedImages.count - 1){
    imageIndex += 1;
    NSImage *theImage = [self getPreviewImageOfPic:selectedImages[imageIndex]];
    [theView setImage:theImage];
    [theView initWatermarkValues:[self getWatermark:selectedImages[imageIndex]]];
    [theView setNeedsDisplay:true];
  }
}

- (IBAction)saveToAperture:(id)sender {
  NSLog(@"Button pressed");
  NSLog(@"%@",[theView watermarkValues]);
  [Aperture writeIPTC:[theView watermarkValues] toField:@"SpecialInstructions" ofPic:[selectedImages[imageIndex] objectForKey:@"name"] ofProject:[selectedImages[imageIndex] objectForKey:@"project"] ofMonth:[selectedImages[imageIndex] objectForKey:@"month"] ofYear:[selectedImages[imageIndex] objectForKey:@"year"]];
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
