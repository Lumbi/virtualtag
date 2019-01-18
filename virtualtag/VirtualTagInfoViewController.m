//
//  VirtualTagInfoViewController.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-31.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "VirtualTagInfoViewController.h"
#import "VirtualTag.h"
#import "User.h"
#import "NSString+Localized.h"

@implementation VirtualTagInfoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.virtualTagNameHeaderLabel.text = [@"kInfoVirtualTagNameHeader" localized];
    self.virtualTagAuthorHeaderLabel.text = [@"kinfoVirtualTagAuthorHeader" localized];
    self.virtualTagExpiryHeaderLabel.text = [@"kInfoVirtualTagExpiryHeader" localized];    
    
    self.virtualTagNameLabel.text = self.virtualTag.title;
    self.virtualTagAuthorLabel.text = self.virtualTag.author.name;
    self.virtualTagExpiryLabel.text = self.virtualTag.timeToLiveDescription;
}

-(IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
