//
//  VirtualTagViewerController.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-08.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@class VirtualTag;

@interface VirtualTagViewerController : UIViewController

@property(nonatomic, weak) IBOutlet UILabel* virtualTagTimeToLiveLabel;
@property(nonatomic, weak) IBOutlet UILabel* virtualTagLikesCountLabel;

@property(nonatomic, weak) IBOutlet LoadingView* loadingView;

@property(nonatomic, strong) VirtualTag* virtualTag;

@property(nonatomic, weak) IBOutlet UIImageView* markerImageView;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint* markerImageWidthConstraint;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint* markerImageHeightConstraint;

@property(nonatomic, weak) IBOutlet UIButton* backButton;

-(IBAction)back:(id)sender;
-(IBAction)like:(id)sender;
-(IBAction)showMarkerImage:(id)sender;

@end
