//
//  VirtualTagPoint.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-06.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "VirtualTagPoint.h"

@implementation VirtualTagPoint

-(id)initWithPosition:(CGPoint)position
{
    if(self = [super init])
    {
        self.position = position;
    }
    return self;
}

-(id)dictionaryRepresentation
{
    return @{ @"x" : @(self.position.x), @"y" : @(self.position.y) };
}

-(id)fromDictionary:(id)dict
{
    self.position = CGPointMake(dict[@"x"] ? [dict[@"x"] doubleValue] : 0,
                                dict[@"y"] ? [dict[@"y"] doubleValue] : 0);
    return self;
}

@end