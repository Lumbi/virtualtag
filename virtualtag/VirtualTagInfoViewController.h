//
//  VirtualTagInfoViewController.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-31.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VirtualTag;

@interface VirtualTagInfoViewController : UIViewController

@property(nonatomic, strong) VirtualTag* virtualTag;

@property(nonatomic, weak) IBOutlet UILabel* virtualTagNameHeaderLabel;
@property(nonatomic, weak) IBOutlet UILabel* virtualTagNameLabel;
@property(nonatomic, weak) IBOutlet UILabel* virtualTagAuthorHeaderLabel;
@property(nonatomic, weak) IBOutlet UILabel* virtualTagAuthorLabel;
@property(nonatomic, weak) IBOutlet UILabel* virtualTagExpiryHeaderLabel;
@property(nonatomic, weak) IBOutlet UILabel* virtualTagExpiryLabel;

-(IBAction)dismiss:(id)sender;

@end
