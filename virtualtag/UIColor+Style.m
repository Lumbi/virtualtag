//
//  UIColor+Style.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-10.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "UIColor+Style.h"

@implementation UIColor (Style)

+(UIColor*) backgroundColor
{
    return [UIColor whiteColor];
}

+(UIColor*) baseColor
{
    return [UIColor colorWithHex:0x181619];
}

+(UIColor*) accentColor
{
    return [UIColor colorWithHex:0xE32F21];
}

+(UIColor*) colorWithHex:(NSUInteger)hex
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 \
                           green:((float)((hex & 0x00FF00) >>  8))/255.0 \
                            blue:((float)((hex & 0x0000FF) >>  0))/255.0 \
                           alpha:1.0];
}

@end
