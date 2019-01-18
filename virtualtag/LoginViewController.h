//
//  LoginViewController.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-15.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic, weak) IBOutlet LoadingView* loadingView;

@property(nonatomic, weak) IBOutlet UILabel* errorLabel;
@property(nonatomic, weak) IBOutlet UILabel* titleLabel;
@property(nonatomic, weak) IBOutlet UITextField* userNameTextField;
@property(nonatomic, weak) IBOutlet UIButton* connectButton;

-(IBAction)connect:(id)sender;

@end
