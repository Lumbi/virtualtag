//
//  UIColor+Style.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-10.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Style)

+(UIColor*) backgroundColor;
+(UIColor*) baseColor;
+(UIColor*) accentColor;

+(UIColor*) colorWithHex:(NSUInteger)hex;

@end
