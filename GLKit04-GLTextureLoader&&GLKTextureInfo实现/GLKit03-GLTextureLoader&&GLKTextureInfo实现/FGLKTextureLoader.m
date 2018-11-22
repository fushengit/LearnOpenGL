//
//  FGLKTextureLoader.m
//  GLKit03-GLTextureLoader&&GLKTextureInfo实现
//
//  Created by Fu,Sheng on 2018/11/22.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import "FGLKTextureLoader.h"
#import <GLKit/GLKit.h>
#include "math.h"

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
    GLuint name;
    GLsizei width;
    GLsizei height;
    NSData *data;
    [self resizedCGImage:cgImage
                   width:&width
                  height:&height
                    data:data];
    // step1
    glGenTextures(1, &name);
    // step2
    glBindTexture(GL_TEXTURE_2D, name);
    // step3
    glTexImage2D(GL_TEXTURE_2D,
                 0,         // MIP贴图初始级别，如果不使用MIP贴图就填0。
                 GL_RGBA,   // 指定纹理缓存中每个纹素需要保存的信息。 在iOS平台下只有GL_RGB和GL_RGBA。
                 width,     // 指定图像的宽度。 这里需要注意的是一定要是2的幂。
                 height,    // 指定图像的高度。 同样也要是2的幂。
                 0,         // border 围绕纹理的纹素的边界大小，一般都是是0。
                 GL_RGBA,   // 指定初始化缓存中所使用的图像数据中的每个像素所要保存的信息。
                            // 这个一般和纹理中纹素需要保存的信息相同，如果不同的话会自动的执行图像格式数据转换。
                 GL_UNSIGNED_BYTE, //指定缓存中纹素数据所使用的位编码类型。有以下几种：
                                    //GL_UNSIGNED_BYTE  纹素中每个颜色元素需要1个字节来保存。RGBA类型就需要4个字节，32位保存。
                                    //GL_UNSIGNED_SHORT_5_6_5 将纹素中所有颜色用2个字节，16位保存。 5位红色，5位绿色，5位蓝色，没有透明度。
                                    //GL_UNSIGNED_SHORT_4_4_4_4 将纹素中所有颜色用2个字节，16位保存。4位R,4位G,4位B,4位A。
                                    //GL_UNSIGNED_SHORT_5_5_5_1 将纹素中所有颜色用2个字节，16位保存。5位R,5位G,5位B,1位A
                 [data bytes]); // 需要被赋值到绑定的纹理缓存中的图片的像素颜色数据的指针
    
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    if (glGetError() != GL_NO_ERROR) {
        NSLog(@"load texture fail");
    }
    return [[FGLKTextureInfo alloc] initWith:name
                                      target:GL_RGBA
                                       width:width
                                      height:height];
}


+ (void)resizedCGImage:(CGImageRef)cgImage
                 width:(GLsizei *)width
                height:(GLsizei *)height
                  data:(NSData *)data{
    
    size_t originalW = CGImageGetWidth(cgImage);
    size_t originalH = CGImageGetHeight(cgImage);
    
    // 1. 计算长宽最接近的2的幂。
    GLsizei pWidth = pow(2, 10);
    GLsizei pHeight = pow(2, 10);
    for (int i = 0; i < 9; i++) {
        GLsizei min = pow(2, i);
        GLsizei max = pow(2, i+1);
        if (originalW >min && originalW <= max) {
            pWidth = max;
        }
        if (originalH >min && originalH <= max) {
            pHeight = max;
        }
    }
    
    // 2. 开辟data空间
    NSMutableData *mData = [NSMutableData dataWithLength: pWidth * pHeight * 4];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate([mData mutableBytes],
                                                 pWidth,
                                                 pHeight,
                                                 8,
                                                 pWidth * 4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, pWidth, pHeight), cgImage);
    
    
    CGContextTranslateCTM (context, 0, pHeight);
    CGContextScaleCTM (context, 1.0, -1.0);
    
    CGContextRelease(context);
    
    *width = pWidth;
    *height = pHeight;
    data = mData;
}

@end
