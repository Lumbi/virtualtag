//
//  NSString+Localized.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-08.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "NSString+Localized.h"

@implementation NSString (Localized)

-(NSString*) localized;
{
    return NSLocalizedString(self, nil);
}

@end
