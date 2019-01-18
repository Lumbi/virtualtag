//
//  VirtualTagDrawView.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-05.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "VirtualTagDrawView.h"
#import "VirtualTagLine.h"
#import "VirtualTagPoint.h"
#import "VirtualTagRenderer.h"

@interface VirtualTagDrawView ()

@property(nonatomic, strong) VirtualTagRenderer* renderer;

@end

@implementation VirtualTagDrawView

-(instancetype)init
{
    if(self = [super init])
    {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.renderer = [VirtualTagRenderer new];
}

-(void)drawRect:(CGRect)rect
{
    if(self.virtualTag)
    {
        [self.renderer renderTag:self.virtualTag inContext:UIGraphicsGetCurrentContext()];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    [self.delegate virtualTagDrawView:self didBeginLineAt:[touch locationInView:self] withFinger:0];
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    [self.delegate virtualTagDrawView:self didContinueLineAt:[touch locationInView:self] withFinger:0];
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    [self.delegate virtualTagDrawView:self didEndLine:[touch locationInView:self] withFinger:0];
    [self setNeedsDisplay];
}

@end
