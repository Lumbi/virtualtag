//
//  Dictionary.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-16.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@protocol Dictionary <NSObject>

-(id)dictionaryRepresentation;
-(id)fromDictionary:(id)dictionary;

@end

@interface NSArray (Dictionary)

-(NSArray*)dictionaryRepresentationArray;
+(NSArray*)fromDictionaryArray:(NSArray*)dictionaries of:(Class)type;

@end

id CGSizeDictionaryRepresentation(CGSize size);
CGSize CGSizeFromDictionary(id dictionary);

id CLLocationCoordinate2DDictionaryRepresentation(CLLocationCoordinate2D coord);
CLLocationCoordinate2D CLLocationCoordinate2DFromDictionary(id dictionary);

id UIColorDictionaryRepresentation(UIColor* color);
UIColor* UIColorFromDictionary(id dictionary);

id NSDateFromDictionary(id dictionary);