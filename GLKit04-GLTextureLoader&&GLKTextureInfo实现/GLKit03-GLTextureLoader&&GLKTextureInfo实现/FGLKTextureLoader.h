//
//  FGLKTextureLoader.h
//  GLKit03-GLTextureLoader&&GLKTextureInfo实现
//
//  Created by Fu,Sheng on 2018/11/22.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

@interface FGLKTextureInfo :NSObject
@property (readonly) GLuint name;
@property (readonly) GLenum target;
@property (readonly) GLuint width;
@property (readonly) GLuint height;
@end

@interface FGLKTextureLoader : NSObject
+ (FGLKTextureInfo *)textureWithCGImage:(CGImageRef)cgImage
                                options:(nullable NSDictionary<NSString*, NSNumber*> *)options
                                  error:(NSError * __nullable * __nullable)outError;
@end
