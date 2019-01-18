//
//  LoadingView.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-16.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView ()

@property(nonatomic, strong) CAShapeLayer* loadingBarLayer;

@end

@implementation LoadingView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

-(instancetype)init
{
    if(self = [super init])
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.opaque = NO;
    
    self.loadingBarLayer = [CAShapeLayer layer];
    self.loadingBarLayer.fillColor = [UIColor whiteColor].CGColor;
    self.loadingBarLayer.path = CGPathCreateWithRect(CGRectMake(0, 0, self.frame.size.width*2, 100), nil);
    self.loadingBarLayer.transform = CATransform3DMakeRotation(M_PI_4, 0, 0, 1);
    
    [self.layer addSublayer:self.loadingBarLayer];
    
    self.hidden = YES;
}

-(void)startAnimating
{
    self.hidden = NO;
    
    [self.loadingBarLayer removeAllAnimations];
    
    CABasicAnimation* loadingBarAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    loadingBarAnimation.fromValue = @(-self.frame.size.height);
    loadingBarAnimation.toValue = @(self.frame.size.height);
    loadingBarAnimation.repeatCount = HUGE_VALF;
    loadingBarAnimation.duration = 1.2;
    
    [self.loadingBarLayer addAnimation:loadingBarAnimation forKey:nil];
    
}

-(void)stopAnimating
{
    self.hidden = YES;
    
    [self.loadingBarLayer removeAllAnimations];
}

@end
