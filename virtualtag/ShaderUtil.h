//
//  ShaderUtil.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-09.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShaderUtil : NSObject

+ (int)createProgramWithVertexShaderFileName:(NSString*) vertexShaderFileName
                      fragmentShaderFileName:(NSString*) fragmentShaderFileName;

+ (int)createProgramWithVertexShaderFileName:(NSString*) vertexShaderFileName
                        withVertexShaderDefs:(NSString *) vertexShaderDefs
                      fragmentShaderFileName:(NSString *) fragmentShaderFileName
                      withFragmentShaderDefs:(NSString *) fragmentShaderDefs;

@end
