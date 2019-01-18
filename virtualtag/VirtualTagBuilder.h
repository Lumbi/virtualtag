//
//  VirtualTagBuilder.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-03.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VirtualTag, VirtualTagPoint;

typedef void(^VirtualTagLocationBlock)(BOOL success);

@interface VirtualTagBuilder : NSObject

@property(nonatomic, strong, readonly) VirtualTag* virtualTag;
@property(nonatomic, strong) UIColor* lineColor;
@property(nonatomic, assign) CGFloat lineWidth;

-(void)beginLine:(VirtualTagPoint*)point;
-(void)addPointToLine:(VirtualTagPoint*)point;
-(void)endLine:(VirtualTagPoint*)point;

-(void)setSize:(CGSize)size;
-(void)setMarkerWithImage:(UIImage*)image andSize:(CGSize)size;
-(void)setCurrentLocationWithCompletion:(VirtualTagLocationBlock)completion;

-(BOOL)isComplete;

@end