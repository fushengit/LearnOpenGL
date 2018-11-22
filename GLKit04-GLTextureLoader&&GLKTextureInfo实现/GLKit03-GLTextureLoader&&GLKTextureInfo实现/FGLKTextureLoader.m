//
//  FGLKTextureLoader.m
//  GLKit03-GLTextureLoader&&GLKTextureInfo实现
//
//  Created by Fu,Sheng on 2018/11/22.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import "FGLKTextureLoader.h"

@interface FGLKTextureInfo()
{
    GLuint _name;
    GLenum _target;
    GLuint _width;
    GLuint _height;
}
- (instancetype)initWith:(GLuint)name
                  target:(GLenum)target
                   width:(GLuint)width
                  height:(GLuint)height;
@end
@implementation FGLKTextureInfo

- (instancetype)initWith:(GLuint)name
                  target:(GLenum)target
                   width:(GLuint)width
                  height:(GLuint)height {
    if (self = [super init]) {
        _name = name;
        _target = target;
        _width = width;
        _height = height;
    }
    return self;
}
@end

@implementation FGLKTextureLoader

+ (FGLKTextureInfo *)textureWithCGImage:(CGImageRef)cgImage
                                options:(nullable NSDictionary<NSString*, NSNumber*> *)options
                                  error:(NSError * __nullable * __nullable)outError {
    return [[FGLKTextureInfo alloc] init];
}
@end
