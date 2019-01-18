//
//  LineColorPickerView.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-06.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "LineColorPickerView.h"

@implementation LineColorPickerView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        UIView* view = [[[NSBundle mainBundle]
                         loadNibNamed:NSStringFromClass([self class])
                         owner:self
                         options:nil] lastObject];
        view.frame = self.bounds;
        [self addSubview:view];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
