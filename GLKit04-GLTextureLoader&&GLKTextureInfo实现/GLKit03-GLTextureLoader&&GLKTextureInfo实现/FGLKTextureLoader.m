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
    NSData *data= [self resizedCGImage:cgImage
                                 width:&width
                                height:&height];
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
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    if (glGetError() != GL_NO_ERROR) {
        NSLog(@"load texture fail");
    }
    return [[FGLKTextureInfo alloc] initWith:name
                                      target:GL_TEXTURE_2D
                                       width:width
                                      height:height];
}


+ (NSData*)resizedCGImage:(CGImageRef)cgImage
                 width:(GLsizei *)width
                height:(GLsizei *)height{
    // 1. 获取原始像素尺寸
    size_t originalW = CGImageGetWidth(cgImage);
    size_t originalH = CGImageGetHeight(cgImage);
    
    // 2. 将原始像素尺寸的长宽计算成 最接近的 2的幂， 得到我们期望的像素长宽。
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
    
    // 3. 将image重新绘制成我们期望的像素长宽，并将绘制完成后的图像数据存储在data里。
    // 3.1 每个像素我们希望以GL_RGBA的方式存储，而且位编码类型是GL_UNSIGNED_BYTE。所以初始化data的长度是 w*h*4
    NSMutableData *mData = [NSMutableData dataWithLength: pWidth * pHeight * 4];
    // 3.2 选择一个颜色填充模式，这里使用RGB。
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 3.3 创建一个文 用于保存图像操作信息。
    CGContextRef context = CGBitmapContextCreate([mData mutableBytes],  //数据保存指针
                                                 pWidth,                //像素宽
                                                 pHeight,               //像素高
                                                 8,                     //每个像素中的每个颜色元素所需要的bits
                                                 pWidth * 4,            //每一行需要bytes
                                                 colorSpace,            //颜色填充模式
                                                 kCGImageAlphaPremultipliedLast); //Alpha的位置
    CGColorSpaceRelease(colorSpace);
    
    /*
     Core Graphics 以原点在左上角，Y轴向下的形式来保存图片的.
     而纹理坐标系 原点在左下角,T轴向上。
     
                                T
     0-------------> X         /\
     |                          |
     |                          |
     |                          |
     |                          |
     \/                         0---------------> S
     Y
     
     所以需要翻转一下
     */
    
    // 向上移动 pHeight
    CGContextTranslateCTM (context, 0, pHeight);
    // X *1 ，Y * -1
    CGContextScaleCTM (context, 1.0, -1.0);
    // 开始绘图
    CGContextDrawImage(context, CGRectMake(0, 0, pWidth, pHeight), cgImage);
    // 销毁上下文
    CGContextRelease(context);
    
    *width = pWidth;
    *height = pHeight;
    return mData;
}

@end
