//
//  AppDelegate.m
//  WaterMarker
//
//  Created by Iain Wood on 25/11/2014.
//  Copyright (c) 2014 soulflyer. All rights reserved.
//

#import "AppDelegate.h"
@class IWApertureAccess;

@interface IWApertureAccess : NSObject
-(NSString *) getLibrary;
-(NSString *) getDatabase;
-(NSArray *) getSelectedPhotos;
-(NSString *) writeIPTC:(NSString*)iptcData toField:(NSString*)iptcField ofPic:(NSString*)thePic ofProject:(NSString*)theProject ofMonth:(NSString*)theMonth ofYear:(NSString*)theYear;
@end

@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
  IWApertureAccess *ApertureAccess = [[NSClassFromString(@"IWApertureAccess") alloc] init];
  NSString *dataBasePath = [ApertureAccess getDatabase];
  NSLog(@"%@",dataBasePath);
  
  //IWGetPhotos *IWGetPhotosInstance = [[NSClassFromString(@"IWGetPhotos") alloc] init ];
  //NSArray *result2=[IWGetPhotosInstance getPhotos];
  //NSLog(@"%@",result2);
  //NSLog(@"%@",result2[0]);

  
  //IWWriteIPTC *IWWriteIPTCInstance = [[NSClassFromString(@"IWWriteIPTC") alloc] init ];
  //NSString *result=[IWWriteIPTCInstance writeIPTC:@"BL66S15X1Y2" toField:@"SpecialInstructions" ofPic:@"DIW_0035" ofProject:@"04-Marshall" ofMonth:@"June" ofYear:@"2007"];
  //NSLog(@"%@",result);
  
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
