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
  [theView setWatermarkValues:[self getWatermark:selectedImages[0]]];
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
    [theView setWatermarkValues:[self getWatermark:selectedImages[imageIndex]]];
    [theView setNeedsDisplay:true];
  }
}
- (IBAction)nextImage:(id)sender {
  NSLog(@"nextImage button pressed");
  if (imageIndex < selectedImages.count - 1){
    imageIndex += 1;
    NSImage *theImage = [self getPreviewImageOfPic:selectedImages[imageIndex]];
    [theView setImage:theImage];
    [theView setWatermarkValues:[self getWatermark:selectedImages[imageIndex]]];
    [theView setNeedsDisplay:true];
  }
}
@end
