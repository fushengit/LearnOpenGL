//
//  FGLKVertexAttribArrayBuffer.h
//  GLKit05-透明度&&混合
//
//  Created by Fu,Sheng on 2018/11/23.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface FGLKVertexAttribArrayBuffer : NSObject
- (instancetype)initWithStride:(GLsizei)aStride numberOfVerteices:(GLuint)count verteices:(const GLvoid *)vertices usage:(GLenum)usage;
- (void)prepareToDrawAttrib:(GLKVertexAttrib)attrib numberOfCoordinations:(GLint)count offset:(GLsizeiptr)offset enable:(BOOL)enable;
- (void)drawMode:(GLenum)mode start:(GLint)start count:(GLsizei)count;
@end
