//
//  User.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-03.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dictionary.h"

@interface User : NSObject<Dictionary>

@property(nonatomic, copy) NSString* identifier;
@property(nonatomic, copy) NSString* name;
@property(nonatomic, copy) NSString* password;

-(void)saveToUserDefaults;
+(User*)loadFromUserDefaults;

@end
