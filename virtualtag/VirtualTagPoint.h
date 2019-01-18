//
//  VirtualTagPoint.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-06.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Dictionary.h"

@interface VirtualTagPoint : NSObject<Dictionary>

@property(nonatomic, assign) CGPoint position;

-(id)initWithPosition:(CGPoint)position;

@end
