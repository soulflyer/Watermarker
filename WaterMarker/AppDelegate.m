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
  if ([previewArray count] > 1){
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
  [theView setWatermarkImage:[[NSImage alloc] initWithContentsOfFile:@"/Users/iain/Pictures/Watermarks/Soulflyer2000.png"]];
  [self doOpenFiles];

}


- (IBAction)openFiles:(id)sender {
  [self doOpenFiles];
}

-(void)doOpenFiles{
  selectedImages=[Aperture getSelectedPhotos];
  NSImage *theImage = [self getPreviewImageOfPic:selectedImages[0]];
  [theView setImage:theImage];
  [theView initWatermarkValues:[self getWatermark:selectedImages[0]]];
  [self setImageCount:@""];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (IBAction)previousImage:(id)sender {
  if (imageIndex > 0){
    [self setImageIndex:imageIndex - 1];
    //imageIndex -= 1;
    NSImage *theImage = [self getPreviewImageOfPic:selectedImages[imageIndex]];
    [theView setImage:theImage];
    [theView initWatermarkValues:[self getWatermark:selectedImages[imageIndex]]];
    [theView setNeedsDisplay:true];
  }
}

- (IBAction)nextImage:(id)sender {
  if (imageIndex < selectedImages.count - 1){
    [self setImageIndex:imageIndex + 1];
    //imageIndex += 1;
    NSImage *theImage = [self getPreviewImageOfPic:selectedImages[imageIndex]];
    [theView setImage:theImage];
    [theView initWatermarkValues:[self getWatermark:selectedImages[imageIndex]]];
    [theView setNeedsDisplay:true];
  }
}

- (IBAction)saveToAperture:(id)sender {
  int i = imageIndex;
  [Aperture writeIPTC:[theView watermarkValues] toField:@"SpecialInstructions" ofPic:[selectedImages[i] objectForKey:@"name"] ofProject:[selectedImages[i] objectForKey:@"project"] ofMonth:[selectedImages[i] objectForKey:@"month"] ofYear:[selectedImages[i] objectForKey:@"year"]];
}

- (IBAction)saveAndNext:(id)sender {
  [self saveToAperture:sender];
  [self nextImage:sender];
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


-(NSString*)imageCount{
  return [NSString stringWithFormat:@"Image %d of %d",imageIndex + 1, (int)[selectedImages count]];
}

-(void)setImageCount:(NSString*)str {
}

-(int)imageIndex{
  return imageIndex;
}

-(void)setImageIndex:(int)newImageIndex{
  imageIndex=newImageIndex;
  [self setImageCount:@""];
}


@end
