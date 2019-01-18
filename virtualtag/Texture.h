//
//  Texture.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-09.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Texture : NSObject
{
@private
    int channels;
}


// --- Properties ---
@property (nonatomic, readonly) int width;
@property (nonatomic, readonly) int height;
@property (nonatomic, readwrite) int textureID;
@property (nonatomic, readonly) unsigned char* pngData;


// --- Public methods ---
- (id)initWithImageFile:(NSString*)filename;

@end
