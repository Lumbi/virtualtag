//
//  VirtualTagDrawView.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-05.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VirtualTag.h"

@protocol VirtualTagDrawViewDelegate;

@interface VirtualTagDrawView : UIView

@property(nonatomic, weak) VirtualTag* virtualTag;
@property(nonatomic, weak) id<VirtualTagDrawViewDelegate> delegate;

@end

@protocol VirtualTagDrawViewDelegate <NSObject>

-(void)virtualTagDrawView:(VirtualTagDrawView*)drawView didBeginLineAt:(CGPoint)point withFinger:(NSUInteger)finger;
-(void)virtualTagDrawView:(VirtualTagDrawView*)drawView didContinueLineAt:(CGPoint)point withFinger:(NSUInteger)finger;
-(void)virtualTagDrawView:(VirtualTagDrawView*)drawView didEndLine:(CGPoint)point withFinger:(NSUInteger)finger;

@end
