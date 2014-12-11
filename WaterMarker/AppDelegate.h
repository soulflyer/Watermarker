//
//  AppDelegate.h
//  WaterMarker
//
//  Created by Iain Wood on 25/11/2014.
//  Copyright (c) 2014 soulflyer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IWView;
@class IWApertureAccess;

@interface AppDelegate : NSObject <NSApplicationDelegate>{
  IBOutlet IWView *theView;
  IBOutlet NSWindow *window;
  NSArray *selectedImages;
  int imageIndex;
  NSDictionary *selectedImage;
  IWApertureAccess *Aperture;
}
- (IBAction)previousImage:(id)sender;
- (IBAction)nextImage:(id)sender;
- (IBAction)saveToAperture:(id)sender;
- (IBAction)saveAndNext:(id)sender;

-(IBAction)setBottom:(id)sender;
-(IBAction)setTop:(id)sender;
-(IBAction)setLeft:(id)sender;
-(IBAction)setRight:(id)sender;

-(IBAction)moveLeft:(id)sender;
-(IBAction)moveRight:(id)sender;
-(IBAction)moveUp:(id)sender;
-(IBAction)moveDown:(id)sender;
-(IBAction)toggleVisibility:(id)sender;

@end

