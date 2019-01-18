//
//  VirtualTagRenderer.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-10.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "VirtualTagRenderer.h"
#import "VirtualTagLine.h"
#import "VirtualTagPoint.h"
#import "VirtualTag.h"

@implementation VirtualTagRenderer

-(void)renderTag:(VirtualTag*)virtualTag inContext:(CGContextRef)context
{
    if(virtualTag && virtualTag.lines.count > 0)
    {
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetLineCap(context, kCGLineCapRound);
        
        for(VirtualTagLine* line in virtualTag.lines)
        {
            CGContextSetLineWidth(context, line.lineWidth);
            CGContextSetStrokeColorWithColor(context, [line.lineColor CGColor]);
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, [line start].x, [line start].y);
            for(VirtualTagPoint* point in line.points)
            {
                CGContextAddLineToPoint(context, point.position.x, point.position.y);
            }
            CGContextStrokePath(context);
        }
    }
}

-(UIImage*)renderTag:(VirtualTag *)virtualTag
{
    UIGraphicsBeginImageContext(virtualTag.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self renderTag:virtualTag inContext:context];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
