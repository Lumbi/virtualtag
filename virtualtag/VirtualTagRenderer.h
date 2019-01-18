//
//  VirtualTagRenderer.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-10.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@class VirtualTag;

@interface VirtualTagRenderer : NSObject

-(void)renderTag:(VirtualTag*)virtualTag inContext:(CGContextRef)contex;
-(UIImage*)renderTag:(VirtualTag *)virtualTag;

@end
