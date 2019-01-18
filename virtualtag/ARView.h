//
//  ARView.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-08.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QCAR/UIGLViewProtocol.h>
#import "ARSession.h"

@interface ARView : UIView<UIGLViewProtocol>

-(id)initWithFrame:(CGRect)frame usingARSession:(ARSession*)arSession;

@end
