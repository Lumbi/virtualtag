//
//  CaptureButton.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-05.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "CaptureButton.h"

@implementation CaptureButton

- (void)drawRect:(CGRect)rect
{
    self.layer.cornerRadius = self.frame.size.width / 2.0;
    self.layer.masksToBounds = YES;
}

@end
