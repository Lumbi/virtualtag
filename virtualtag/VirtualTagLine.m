//
//  VirtualTagLine.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-03.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "VirtualTagLine.h"
#import "VirtualTagPoint.h"

@implementation VirtualTagLine

-(id)init
{
    if(self = [super init])
    {
        self.points = [NSMutableArray new];
    }
    return self;
}

-(CGPoint)start
{
    if(self.points.count > 0)
    {
        return [self.points[0] position];
    }else{
        return CGPointZero;
    }
}

-(id)dictionaryRepresentation
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    if(self.points) dict[@"points"] = [self.points dictionaryRepresentationArray];
    if(self.lineColor) dict[@"line_color"] = UIColorDictionaryRepresentation(self.lineColor);
    dict[@"line_width"] = @(self.lineWidth);
    return [NSDictionary dictionaryWithDictionary:dict];
}

-(id)fromDictionary:(id)dictionary
{
    self.points = [NSMutableArray arrayWithArray:
                   [NSArray fromDictionaryArray:dictionary[@"points"] of:[VirtualTagPoint class]]];
    self.lineColor = UIColorFromDictionary(dictionary[@"line_color"]);
    self.lineWidth = [dictionary[@"line_width"] doubleValue];
    return self;
}

@end