//
//  CanvasCropView.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-08.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "CanvasCropView.h"

@interface CanvasCropView ()

@property(nonatomic, assign) CGRect originalCropRect;
@property(nonatomic, strong) UIPinchGestureRecognizer* pinchRecognizer;

@end

@implementation CanvasCropView

const CGSize kDefaultCropSize = {200,200};
const CGSize kMinCropSize = {80,80};
const CGSize kMaxCropSize = {300,300};

-(id)init
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

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.cropRect = CGRectMake(CGRectGetMidX(self.bounds)-kDefaultCropSize.width/2.0,
                               CGRectGetMidY(self.bounds)-kDefaultCropSize.height/2.0,
                               kDefaultCropSize.width,
                               kDefaultCropSize.height);
    self.pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch)];
    [self addGestureRecognizer:self.pinchRecognizer];
}

-(void)pinch
{
    if(self.pinchRecognizer.state == UIGestureRecognizerStateBegan)
    {
        self.originalCropRect = self.cropRect;
    }else if(self.pinchRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint center = CGPointMake(CGRectGetMidX(self.cropRect), CGRectGetMidY(self.cropRect));
        
        CGFloat scaledCropWidth = self.originalCropRect.size.width * self.pinchRecognizer.scale;
        CGFloat scaledCropHeight = self.originalCropRect.size.height * self.pinchRecognizer.scale;
        
        if(scaledCropWidth >= kMinCropSize.width &&
           scaledCropWidth <= kMaxCropSize.width &&
           scaledCropHeight >= kMinCropSize.height &&
           scaledCropHeight <= kMaxCropSize.height)
        {
            self.cropRect = CGRectMake(0, 0,
                                       self.originalCropRect.size.width * self.pinchRecognizer.scale,
                                       self.originalCropRect.size.height * self.pinchRecognizer.scale);
            self.cropRect = CGRectOffset(self.cropRect,
                                         center.x - CGRectGetWidth(self.cropRect)/2.0,
                                         center.y - CGRectGetWidth(self.cropRect)/2.0);
        }
        
        [self setNeedsDisplay];
    }
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0 alpha:0.5] CGColor]);
    CGContextFillRect(context, self.bounds);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0 alpha:0.0] CGColor]);
    CGContextFillRect(context, self.cropRect);
}

@end
