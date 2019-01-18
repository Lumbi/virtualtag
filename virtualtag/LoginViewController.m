//
//  LoginViewController.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-15.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "NSString+Localized.h"
#import "WebService.h"
#import "CanvasCaptureViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.errorLabel.text = @"";
    self.titleLabel.text = [@"kLoginTitle" localized];
    [self.connectButton setTitle:[@"kLoginConnect" localized] forState:UIControlStateNormal];
    
    self.userNameTextField.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark Actions

-(void)connect:(id)sender
{
    User* newUser = [User new];
    
    newUser.name = self.userNameTextField.text;
    newUser.password = [NSUUID UUID].UUIDString;
    
    self.errorLabel.text = @"";
    
    if(newUser.name.length < 6)
    {
        self.errorLabel.text = [@"kLoginConnectUserNameTooShortErrorMessage" localized];
        return;
    }
    
    self.connectButton.enabled = NO;
    [self.loadingView startAnimating];
    [[WebService sharedInstance] createUser:newUser
                                 completion:^(NSInteger statusCode)
     {
         self.connectButton.enabled = YES;
         if(statusCode == 200)
         {
             self.errorLabel.text = @"";
             [newUser saveToUserDefaults];
             [[WebService sharedInstance] setBasicAuthWithUsername:newUser.name
                                                       andPassword:newUser.password];
             [self dismissViewControllerAnimated:YES completion:nil];
         } else if (statusCode == 409) {
             self.errorLabel.text = [@"kLoginConnectUserNameTakenErrorMessage" localized];
         } else if (statusCode == 500) {
             self.errorLabel.text = [@"kServerErrorMessage" localized];
         }
     } error:^(NSError *error) {
     } finally:^{
         self.connectButton.enabled = YES;
         [self.loadingView stopAnimating];
     }];
}

#pragma mark -
#pragma mark TextField Delegation

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark Customization

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
