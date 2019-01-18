//
//  VirtualTag.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-03.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Dictionary.h"

@class User, Marker;

@interface VirtualTag : NSObject <MKAnnotation, Dictionary>

@property(nonatomic, copy) NSString* identifier;
@property(nonatomic, copy) NSString* title;
@property(nonatomic, strong) User* author;
@property(nonatomic, strong) NSMutableArray* lines;
@property(nonatomic, assign) CGSize size;
@property(nonatomic, strong) Marker* marker;
@property(nonatomic, assign) CLLocationCoordinate2D location;
@property(nonatomic, strong) NSDate* expirationDate;
@property(nonatomic, readonly) NSTimeInterval timeToLive;
@property(nonatomic, readonly) NSString* timeToLiveDescription;

@end
