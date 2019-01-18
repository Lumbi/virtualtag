//
//  ColorPaletteView.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-06.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "ColorPaletteView.h"
#include "HSVtoRGB.h"

@implementation ColorPaletteView


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat segmentWidth = self.frame.size.width / 360.0;
    CGRect segment = CGRectMake(0, 0, segmentWidth, self.frame.size.height);
    float r,g,b;

    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextSetLineWidth(context, 0);
    
    for(float h = 0; h < 360; h++)
    {
        HSVtoRGB(&r, &g, &b, h, 1, 1);
        CGColorRef colorRef = CGColorCreate(colorSpaceRef, (CGFloat[]){ r, g, b, 1 });
        CGContextSetFillColorWithColor(context, colorRef);
        
        CGContextFillRect(context, segment);
        segment = CGRectOffset(segment, segmentWidth, 0);
        
        CGColorRelease(colorRef);
    }
    
    CGColorSpaceRelease(colorSpaceRef);
}


@end
