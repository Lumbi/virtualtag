//
//  VirtualTagLine.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-03.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Dictionary.h"

@interface VirtualTagLine : NSObject<Dictionary>

@property(nonatomic, strong) NSMutableArray* points;
@property(nonatomic, strong) UIColor* lineColor;
@property(nonatomic, assign) CGFloat lineWidth;

-(CGPoint)start;

@end
