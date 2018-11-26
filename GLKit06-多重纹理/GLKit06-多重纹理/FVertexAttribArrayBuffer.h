//
//  FVertexAttribArrayBuffer.h
//  GLKit06-多重纹理
//
//  Created by Fu,Sheng on 2018/11/23.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface FVertexAttribArrayBuffer : NSObject
- (instancetype)initWithStride:(GLsizei)aStride numberOfVertices:(GLuint)count vertices:(const GLvoid *)vertices usage:(GLenum)usage;

- (void)prepareToDraw:(GLKVertexAttrib)arrrib numberOfCoordinates:(GLint)count offset:(GLsizeiptr)offset enable:(BOOL)enable;

- (void)drawMode:(GLenum)mode start:(GLint)start count:(GLsizei)count;

@end
