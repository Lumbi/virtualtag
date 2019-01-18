//
//  ToolsViewController.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-06.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "ToolsViewController.h"
#include "HSVtoRGB.h"
#import "NSString+Localized.h"

@interface ToolsViewController ()

@property(nonatomic, strong) CAShapeLayer* lineWidthPreviewLayer;

@end

@implementation ToolsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lineWidthPreviewLayer = [CAShapeLayer layer];
    self.lineWidthPreviewLayer.fillColor = [UIColor blackColor].CGColor;
    self.lineWidthPreviewLayer.position = CGPointMake(CGRectGetMidX(self.lineWidthPreviewView.bounds),
                                                      CGRectGetMidY(self.lineWidthPreviewView.bounds));
    
    [self.lineWidthPreviewView.layer addSublayer:self.lineWidthPreviewLayer];
    [self updateLineWidthPreview];
    
    [self.toolButton setTitle:[@"kTools" localized] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)toggleVisibility:(id)sender
{
    [self.delegate toolsViewControllerDidToggleVisibility:self];
}

#pragma mark -
#pragma mark Line Width Tool

-(IBAction)changeLineWidth:(id)sender
{
    self.lineWidth = [(UISlider*)sender value];
    [self.delegate toolsViewController:self didSelectLineWidth:self.lineWidth];
}

-(void)setLineWidth:(float)lineWidth
{
    _lineWidth = lineWidth;
    [self updateLineWidthPreview];
    if(_lineWidth != self.lineWidthSlider.value)
    {
        self.lineWidthSlider.value = _lineWidth;
    }
}

-(void)updateLineWidthPreview
{
    self.lineWidthPreviewLayer.path = CGPathCreateWithEllipseInRect(CGRectMake(-self.lineWidth/2.0,
                                                                               -self.lineWidth/2.0,
                                                                               self.lineWidth,
                                                                               self.lineWidth), nil);
}

#pragma mark -
#pragma mark Line Color Tool

-(IBAction)changeLineColor:(id)sender
{
    CGPoint location = [sender locationInView:self.colorPaletteView];
    
    float hue = 360 * location.x / self.colorPaletteView.frame.size.width;
    float r,g,b;
    
    HSVtoRGB(&r, &g, &b, hue, 1, 1);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorRef = CGColorCreate(colorSpaceRef, (CGFloat[]){ r, g, b, 1 });
    CGColorSpaceRelease(colorSpaceRef);
    
    self.lineColor = [UIColor colorWithCGColor:colorRef];
    CGColorRelease(colorRef);
    
    [self.delegate toolsViewController:self didSelectLineColor:self.lineColor];
}

-(void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.colorPreviewView.backgroundColor = _lineColor;
}

@end
