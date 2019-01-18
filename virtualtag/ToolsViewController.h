//
//  ToolsViewController.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-06.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolsViewControllerDelegate;

@interface ToolsViewController : UIViewController<UIGestureRecognizerDelegate>

@property(nonatomic, weak) id<ToolsViewControllerDelegate> delegate;

@property(nonatomic, weak) IBOutlet UIButton* toolButton;

@property(nonatomic, assign) float lineWidth;
@property(nonatomic, strong) UIColor* lineColor;

@property(nonatomic, weak) IBOutlet UIView* toolsSectionView;

@property(nonatomic, weak) IBOutlet UISlider* lineWidthSlider;
@property(nonatomic, weak) IBOutlet UIView* lineWidthPreviewView;

@property(nonatomic, weak) IBOutlet UIView* colorPaletteView;
@property(nonatomic, weak) IBOutlet UIView* colorPreviewView;

-(IBAction)toggleVisibility:(id)sender;
-(IBAction)changeLineWidth:(id)sender;
-(IBAction)changeLineColor:(id)sender;

@end

@protocol ToolsViewControllerDelegate <NSObject>

-(void)toolsViewControllerDidToggleVisibility:(ToolsViewController*)toolsViewController;
-(void)toolsViewController:(ToolsViewController*)toolsViewController didSelectLineColor:(UIColor*)color;
-(void)toolsViewController:(ToolsViewController*)toolsViewController didSelectLineWidth:(CGFloat)width;

@end
