//
//  FProgramUnit.h
//  GLKit07-自定义纹理
//
//  Created by Fu,Sheng on 2018/12/3.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface FProgramUnit : NSObject

- (instancetype)initWithVertexShaderPath:(NSString *)VertexShaderPath
                      fragmentShaderPath:(NSString *)fragmentShaderPath
                          attribLocation:(NSDictionary<NSString *,NSNumber *> *)attribLocation
                         uniformLocation:(NSMutableDictionary<NSString *,NSNumber *> *)uniformLocation;

- (void)use;
@end


