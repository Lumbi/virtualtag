//
//  VirtualTagBuilder.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-03.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "VirtualTagBuilder.h"
#import "VirtualTag.h"
#import "VirtualTagLine.h"
#import "Marker.h"
#import "UIImage+Scaled.h"

@interface VirtualTagBuilder () <CLLocationManagerDelegate>

@property(readwrite) VirtualTag* virtualTag;
@property(nonatomic, strong) VirtualTagLine* currentlyDrawingLine;
@property(nonatomic, strong) CLLocationManager* locationManager;
@property(nonatomic, copy) VirtualTagLocationBlock virtualTagLocationBlock;

@end

@implementation VirtualTagBuilder

-(id)init
{
    if(self = [super init])
    {
        self.lineColor = [UIColor redColor];
        self.lineWidth = 5;
        
        self.virtualTag = [VirtualTag new];
    }
    return self;
}

#pragma mark -
#pragma mark Public Interface

-(void)beginLine:(VirtualTagPoint*)point
{
    self.currentlyDrawingLine = [VirtualTagLine new];
    self.currentlyDrawingLine.lineColor = self.lineColor;
    self.currentlyDrawingLine.lineWidth = self.lineWidth;
    [self.currentlyDrawingLine.points addObject:point];
    [self.virtualTag.lines addObject:self.currentlyDrawingLine];
}

-(void)addPointToLine:(VirtualTagPoint*)point
{
    [self.currentlyDrawingLine.points addObject:point];
}

-(void)endLine:(VirtualTagPoint*)point
{
    [self.currentlyDrawingLine.points addObject:point];
    self.currentlyDrawingLine = nil;
}

-(void)setSize:(CGSize)size
{
    self.virtualTag.size = size;
}

-(void)setMarkerWithImage:(UIImage*)image andSize:(CGSize)size
{
    self.virtualTag.marker = [[Marker alloc]
                              initWithImage:[image scaledToSize:size]
                              andSize:size];
}

-(void)setCurrentLocationWithCompletion:(VirtualTagLocationBlock)completion
{
    if(!self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.virtualTagLocationBlock = completion;
    
    if([CLLocationManager locationServicesEnabled] &&
       ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)
       )
    {
        [self.locationManager startUpdatingLocation];
    }else{
        [self.locationManager requestWhenInUseAuthorization];
    }
}

-(BOOL)isComplete
{
    return
    self.virtualTag.location.latitude != 0 &&
    self.virtualTag.location.longitude != 0;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
    self.virtualTag.location = location.coordinate;
    [self.locationManager stopUpdatingLocation];
    if(self.virtualTagLocationBlock)
    {
        self.virtualTagLocationBlock(YES);
        self.virtualTagLocationBlock = nil;
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(self.virtualTagLocationBlock)
    {
        if(status == kCLAuthorizationStatusAuthorizedWhenInUse ||
           status == kCLAuthorizationStatusAuthorizedAlways)
        {
            [self.locationManager startUpdatingLocation];
        } else {
            self.virtualTagLocationBlock(NO);
            self.virtualTagLocationBlock = nil;
        }
    }
}

@end
