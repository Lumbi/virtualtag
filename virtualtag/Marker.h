//
//  Marker.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-10.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Dictionary.h"

@interface Marker : NSObject<Dictionary>

@property(nonatomic, strong) NSString* dataset;
@property(nonatomic, strong) UIImage* image;
@property(nonatomic, assign) CGSize size;

-(id)initWithImage:(UIImage*)image andSize:(CGSize)size;

@end
