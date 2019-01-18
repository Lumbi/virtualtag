//
//  User.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-03.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "User.h"

#define kNSUserDefaultUserNameKey @"com.lumbi.virtualtag.user.name"
#define kNSUserDefaultUserPasswordKey @"com.lumbi.virtualtag.user.password"

@implementation User

-(void)saveToUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:self.name
                                              forKey:kNSUserDefaultUserNameKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.password
                                              forKey:kNSUserDefaultUserPasswordKey];
}

+(User*)loadFromUserDefaults
{
    User* user = [User new];
    user.name = [[NSUserDefaults standardUserDefaults]
                 stringForKey:kNSUserDefaultUserNameKey];
    user.password = [[NSUserDefaults standardUserDefaults]
                     stringForKey:kNSUserDefaultUserPasswordKey];
    
    if(user.name && user.password)
    {
        return user;
    }else{
        return nil;
    }
}

-(id)dictionaryRepresentation
{
    return self.identifier;
}

-(id)fromDictionary:(id)dictionary
{
    self.identifier = dictionary[@"id"];
    self.name = dictionary[@"name"];
    return self;
}

@end
