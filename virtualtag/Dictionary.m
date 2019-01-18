//
//  Dictionary.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-16.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Dictionary.h"

@implementation NSArray (Dictionary)

-(NSArray*)dictionaryRepresentationArray
{
    NSMutableArray* array = [NSMutableArray new];
    for(id object in self)
    {
        if([object conformsToProtocol:@protocol(Dictionary)])
        {
            [array addObject:[object dictionaryRepresentation]];
        }
    }
    return [NSArray arrayWithArray:array];
}

+(NSArray*)fromDictionaryArray:(NSArray*)dictionaries of:(Class)type;
{
    NSMutableArray* array = [NSMutableArray new];
    if([type conformsToProtocol:@protocol(Dictionary)])
    {
        for(id dictionary in dictionaries)
        {
            id object = [[type alloc]init];
            [object fromDictionary:dictionary];
            [array addObject:object];
        }
    }
    return [NSArray arrayWithArray:array];
}

@end

id CGSizeDictionaryRepresentation(CGSize size)
{
    return @{ @"width" : @(size.width), @"height" : @(size.height) };
}

CGSize CGSizeFromDictionary(id dictionary)
{
    return CGSizeMake(dictionary[@"width"] ? [dictionary[@"width"] doubleValue] : 0,
                      dictionary[@"height"] ? [dictionary[@"height"] doubleValue] : 0);
}

id CLLocationCoordinate2DDictionaryRepresentation(CLLocationCoordinate2D coord)
{
    return @{@"latitude" : @(coord.latitude), @"longitude" : @(coord.longitude) };
}

CLLocationCoordinate2D CLLocationCoordinate2DFromDictionary(id dict)
{
    return CLLocationCoordinate2DMake(
                                      dict[@"latitude"] ? [dict[@"latitude"] doubleValue] : 0,
                                      dict[@"longitude"] ? [dict[@"longitude"] doubleValue] : 0);
}

id UIColorDictionaryRepresentation(UIColor* color)
{
    CGFloat r, g, b, a;
    [color getRed: &r green:&g blue:&b alpha:&a];
    return @{ @"rgba" : @[@(r),@(g),@(b),@(a)] };
}

UIColor* UIColorFromDictionary(id dict)
{
    NSArray* rgba = dict[@"rgba"];
    return [UIColor colorWithRed:[rgba[0] doubleValue]
                           green:[rgba[1] doubleValue]
                            blue:[rgba[2] doubleValue]
                           alpha:[rgba[3] doubleValue]];
}

id NSDateFromDictionary(id dictionary)
{
    static NSDateFormatter* dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    }
    return [dateFormatter dateFromString:dictionary];
}



