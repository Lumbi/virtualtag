//
//  CanvasCaptureViewController.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-05.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CanvasCropView;

@interface CanvasCaptureViewController : UIViewController

@property(nonatomic, weak) IBOutlet UIButton* captureButton;
@property(nonatomic, weak) IBOutlet UIView* cameraPreviewView;

@property(nonatomic, weak) IBOutlet UILabel* findPiecesButton;

-(IBAction)capture:(id)sender;

@end