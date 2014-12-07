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
@end

