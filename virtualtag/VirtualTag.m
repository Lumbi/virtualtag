//
//  VirtualTag.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-03.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "VirtualTag.h"
#import "User.h"
#import "Marker.h"
#import "VirtualTagLine.h"
#import "NSString+Localized.h"

@implementation VirtualTag

-(id)init
{
    if(self = [super init])
    {
        self.lines = [NSMutableArray new];
    }
    return self;
}

-(NSTimeInterval)timeToLive
{
    return [self.expirationDate timeIntervalSinceNow];
}

-(NSString *)timeToLiveDescription
{
    NSTimeInterval timeToLive = self.timeToLive;
    
    if(timeToLive > 0)
    {
        NSUInteger days = floor(timeToLive / 60.0 / 60.0 / 24.0);
        NSUInteger hours = floor(timeToLive / 60.0 / 60.0);
        NSUInteger minutes = floor(timeToLive / 60.0);
        
        NSUInteger timeUnit = 0;
        NSString* timeUnitStringKey = nil;
        
        if(days >= 1)
        {
            timeUnit = days;
            timeUnitStringKey = @"kDay";
        } else if(hours >= 1)
        {
            timeUnit = hours;
            timeUnitStringKey = @"kHour";
        } else
        {
            timeUnit = minutes;
            timeUnitStringKey = @"kMinute";
        }
        
        if(timeUnit == 1)
        {
            return [NSString stringWithFormat:[@"kExpiryTimeFormat" localized],
                    timeUnit, [timeUnitStringKey localized]];
        } else {
            return [NSString stringWithFormat:[@"kExpiryTimeFormat" localized],
                    timeUnit, [[timeUnitStringKey stringByAppendingString:@"Plurar"] localized]];
        }
    }
    
    return [@"kExpired" localized];
}

-(CLLocationCoordinate2D)coordinate
{
    return self.location;
}

-(NSString *)subtitle
{
    return [NSString stringWithFormat:@"%@ %@ - (%@)", [@"kBy" localized], self.author.name, self.timeToLiveDescription];
}

-(id)dictionaryRepresentation
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    if(self.title) dict[@"title"] = self.title;
    if(self.lines) dict[@"lines"] = [self.lines dictionaryRepresentationArray];
    dict[@"size"] = CGSizeDictionaryRepresentation(self.size);
    if(self.marker) dict[@"marker"] = [self.marker dictionaryRepresentation];
    dict[@"location"] = CLLocationCoordinate2DDictionaryRepresentation(self.location);
    return [NSDictionary dictionaryWithDictionary:dict];
}

-(id)fromDictionary:(id)dict
{
    self.identifier = dict[@"id"];
    self.title = dict[@"title"];
    self.author = [[User new] fromDictionary:dict[@"author"]];
    self.lines = [NSMutableArray arrayWithArray:
                  [NSArray fromDictionaryArray:dict[@"lines"] of:[VirtualTagLine class]]];
    self.size = CGSizeFromDictionary(dict[@"size"]);
    self.marker = [[Marker new] fromDictionary:dict[@"marker"]];
    self.location = CLLocationCoordinate2DFromDictionary(dict[@"location"]);
    self.expirationDate = NSDateFromDictionary(dict[@"exp_date"]);
    return self;
}

-(NSString *)description
{
    return [[self dictionaryRepresentation] description];
}

@end
