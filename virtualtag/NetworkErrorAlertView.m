//
//  NetworkErrorAlertView.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-15.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "NetworkErrorAlertView.h"
#import "NSString+Localized.h"

@implementation NetworkErrorAlertView

-(id)init
{
    if(self = [super initWithTitle:[@"kNetworkErrorTitle" localized]
                           message:[@"kNetworkErrorMessage" localized]
                          delegate:nil
                 cancelButtonTitle:[@"kDismiss" localized]
                 otherButtonTitles:nil])
    {
    }
    return self;
}

@end
