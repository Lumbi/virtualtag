//
//  Marker.m
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-10.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#import "Marker.h"

@implementation Marker

-(id)initWithImage:(UIImage*)image andSize:(CGSize)size
{
    if(self = [super init])
    {
        self.image = image;
        self.size = size;
    }
    return self;
}

-(id)dictionaryRepresentation
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    if(self.dataset) dict[@"dataset"] = self.dataset;
    if(self.image)
    {
        NSData* imageData = UIImageJPEGRepresentation(self.image, 0.8);
        dict[@"image_png_data"] = [imageData base64EncodedStringWithOptions:0];
    }
    dict[@"size"] = CGSizeDictionaryRepresentation(self.size);
    return [NSDictionary dictionaryWithDictionary:dict];
}

-(id)fromDictionary:(id)dict
{
    if(dict[@"image_png_data"])
    {
        NSData* imageData = [[NSData alloc] initWithBase64EncodedString:dict[@"image_png_data"] options:0];
        self.image = [UIImage imageWithData:imageData];
    }
    self.size = CGSizeFromDictionary(dict[@"size"]);
    self.dataset = dict[@"dataset"];
    return self;
}

@end
