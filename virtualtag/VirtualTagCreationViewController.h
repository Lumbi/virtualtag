//
//  VirtualTagCreationViewController.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-05.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VirtualTagDrawView.h"
#import "ToolsViewController.h"
#import "LoadingView.h"

@interface VirtualTagCreationViewController : UIViewController<VirtualTagDrawViewDelegate, ToolsViewControllerDelegate, UIAlertViewDelegate>

@property(nonatomic, weak) IBOutlet UIImageView* canvasImageView;
@property(nonatomic, strong) UIImage* captureImage;

@property(nonatomic, weak) IBOutlet VirtualTagDrawView* virtualTagDrawView;

@property(nonatomic, weak) ToolsViewController* toolsViewController;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint* toolsViewControllerBottomConstraint;

@property(nonatomic, weak) IBOutlet LoadingView* loadingView;

@property(nonatomic, weak) IBOutlet UIButton* doneButton;

-(IBAction)dismiss:(id)sender;
-(IBAction)done:(id)sender;

@end
