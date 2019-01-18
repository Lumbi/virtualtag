//
//  UIImage+Scaled.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-29.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "UIImage+Scaled.h"

@implementation UIImage (Scaled)

-(UIImage*)scaledBy:(CGFloat)scale
{
    CGSize scaledSize = [self size];
    scaledSize.width *= scale;
    scaledSize.height *= scale;
    
    UIGraphicsBeginImageContext(scaledSize);
    [self drawInRect:CGRectMake(0,0,scaledSize.width,scaledSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(UIImage*)scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
