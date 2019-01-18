//
//  VirtualTagCreationViewController.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-05.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "VirtualTagCreationViewController.h"
#import "VirtualTagBuilder.h"
#import "VirtualTagDrawView.h"
#import "VirtualTagPoint.h"
#import "ToolsViewController.h"
#import "VirtualTagViewerController.h"
#import "VirtualTagRenderer.h"
#import "WebService.h"
#import "NSString+Localized.h"

@interface VirtualTagCreationViewController ()

@property(nonatomic, strong) VirtualTagBuilder* virtualTagBuilder;
@property(nonatomic, strong) UIImage* renderedTag;
@property(nonatomic, strong) UIAlertView* nameVirtualTagAlertView;

@end

@implementation VirtualTagCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.virtualTagBuilder = [VirtualTagBuilder new];
    [self.virtualTagBuilder setSize:self.view.frame.size];
    
    self.virtualTagDrawView.delegate = self;
    self.virtualTagDrawView.virtualTag = self.virtualTagBuilder.virtualTag;
    
    self.toolsViewController.lineWidth = self.virtualTagBuilder.lineWidth;
    self.toolsViewController.lineColor = self.virtualTagBuilder.lineColor;
    
    self.canvasImageView.image = self.captureImage;
    
    self.nameVirtualTagAlertView = [[UIAlertView alloc]
                                    initWithTitle:[@"kCreateVirtualTagTitleMessage" localized]
                                    message:nil
                                    delegate:self
                                    cancelButtonTitle:[@"kCancel" localized]
                                    otherButtonTitles:[@"kOK" localized], nil];
    self.nameVirtualTagAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    self.doneButton.enabled = NO;
    self.doneButton.hidden = YES;
    [self.doneButton setTitle:[@"kCreateVirtualTagDoneButton" localized] forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateDoneButton];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateVirtualTagLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Model Update

-(void)updateVirtualTagLocation
{
    if(self.virtualTagBuilder.virtualTag.location.latitude == 0 &&
       self.virtualTagBuilder.virtualTag.location.longitude == 0)
    {
        __block id bself = self;
        [self.virtualTagBuilder setCurrentLocationWithCompletion:^(BOOL success)
         {
             [bself updateDoneButton];
             
             if(!success)
             {
                 UIAlertController* locationAlertController =
                 [UIAlertController
                  alertControllerWithTitle:[@"kCreateVirtualTagLocationErrorTitle" localized]
                  message:[@"kCreateVirtualTagLocationErrorMessage" localized]
                  preferredStyle:UIAlertControllerStyleAlert];
                 
                 [locationAlertController addAction:[UIAlertAction
                                                     actionWithTitle:[@"kDismiss" localized]
                                                     style:UIAlertActionStyleCancel
                                                     handler:nil]];
                 
                 [locationAlertController addAction:
                  [UIAlertAction
                   actionWithTitle:[@"kCreateVirtualTagLocationOpenSettings" localized]
                   style:UIAlertActionStyleDefault
                   handler:^(UIAlertAction *action) {
                       [[UIApplication sharedApplication] openURL:
                        [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                   }]];
                 
                 [bself presentViewController:locationAlertController animated:YES completion:nil];
             }
         }];
    }
}

#pragma mark -
#pragma mark UI Update

-(void)updateDoneButton
{
    self.doneButton.enabled = [self.virtualTagBuilder isComplete];
    self.doneButton.hidden = ![self.virtualTagBuilder isComplete];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue destinationViewController] isKindOfClass:[ToolsViewController class]])
    {
        self.toolsViewController = (ToolsViewController*)[segue destinationViewController];
        self.toolsViewController.delegate = self;
    }
}

-(IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)done:(id)sender
{
    [self.virtualTagBuilder setMarkerWithImage:self.captureImage
                                       andSize:self.canvasImageView.frame.size];
    [self.nameVirtualTagAlertView show];
}

-(void)createVirtualTag
{
    [self.loadingView startAnimating];
    [[WebService sharedInstance] createVirtualTag:self.virtualTagBuilder.virtualTag
                                       completion:^(id object, NSInteger statusCode)
     {
         switch (statusCode) {
             case 200:
                 self.virtualTagBuilder.virtualTag.identifier = object;
                 self.doneButton.hidden = YES;
                 self.virtualTagDrawView.userInteractionEnabled = NO;
                 [[[UIAlertView alloc] initWithTitle:[@"kCreateVirtualTagUploadSuccessTitle" localized]
                                            message:[@"kCreateVirtualTagUploadSuccessMessage" localized]
                                           delegate:nil
                                  cancelButtonTitle:[@"kAwesome" localized]
                                  otherButtonTitles:nil] show];
                 break;
             default:
                 [[[UIAlertView alloc] initWithTitle:[@"kCreateVirtualTagUploadFailedTitle" localized]
                                             message:[@"kCreateVirtualTagUploadFailedMessage" localized]
                                            delegate:nil
                                   cancelButtonTitle:[@"kDismiss" localized]
                                   otherButtonTitles:nil] show];
                 break;
         }
     } error:^(NSError *error) {
     } finally:^{
         [self.loadingView stopAnimating];
     }];
}

#pragma mark -
#pragma mark Alert View Delegation

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == self.nameVirtualTagAlertView){
        
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            self.virtualTagBuilder.virtualTag.title = [alertView textFieldAtIndex:0].text;
            
            if(self.virtualTagBuilder.virtualTag.title.length > 0){
                [self createVirtualTag];
            }
        }
    }
}

#pragma mark -
#pragma mark Virtual Tag Draw View Delegation

-(void)virtualTagDrawView:(VirtualTagDrawView *)drawView
           didBeginLineAt:(CGPoint)point
               withFinger:(NSUInteger)finger
{
    [self.virtualTagBuilder beginLine:[[VirtualTagPoint alloc] initWithPosition:point]];
}

-(void)virtualTagDrawView:(VirtualTagDrawView *)drawView
        didContinueLineAt:(CGPoint)point
               withFinger:(NSUInteger)finger
{
    [self.virtualTagBuilder addPointToLine:[[VirtualTagPoint alloc] initWithPosition:point]];
}

-(void)virtualTagDrawView:(VirtualTagDrawView *)drawView
               didEndLine:(CGPoint)point
               withFinger:(NSUInteger)finger
{
    [self.virtualTagBuilder endLine:[[VirtualTagPoint alloc] initWithPosition:point]];
}

#pragma mark -
#pragma mark Tools View Controller Delegation

-(void)toolsViewControllerDidToggleVisibility:(ToolsViewController *)toolsViewController
{
    if(self.toolsViewControllerBottomConstraint.constant != 0)
    {
        self.toolsViewControllerBottomConstraint.constant = 0;
    }else{
        self.toolsViewControllerBottomConstraint.constant =
        -self.toolsViewController.toolsSectionView.frame.size.height;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

-(void)toolsViewController:(ToolsViewController *)toolsViewController didSelectLineColor:(UIColor *)color
{
    self.virtualTagBuilder.lineColor = color;
}

-(void)toolsViewController:(ToolsViewController *)toolsViewController didSelectLineWidth:(CGFloat)width
{
    self.virtualTagBuilder.lineWidth = width;
}

#pragma mark -
#pragma mark Notification Center

-(void)applicationDidBecomeActive
{
    [self updateVirtualTagLocation];
}

#pragma mark -
#pragma mark Customization

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
