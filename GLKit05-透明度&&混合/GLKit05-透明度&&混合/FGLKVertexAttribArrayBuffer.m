//
//  FGLKVertexAttribArrayBuffer.m
//  GLKit05-透明度&&混合
//
//  Created by Fu,Sheng on 2018/11/23.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import "FGLKVertexAttribArrayBuffer.h"
@interface FGLKVertexAttribArrayBuffer()
{
    GLuint name;
    GLsizei stride;
}
@end

@implementation FGLKVertexAttribArrayBuffer

- (instancetype)initWithStride:(GLsizei)aStride numberOfVerteices:(GLuint)count verteices:(const GLvoid *)vertices usage:(GLenum)usage
{
    self = [super init];
    if (self) {
        stride = aStride;
        glGenBuffers(1, &name);
        glBindBuffer(GL_ARRAY_BUFFER, name);
        glBufferData(GL_ARRAY_BUFFER,
                     aStride * count,
                     vertices,
                     usage);
    }
    return self;
}


- (void)prepareToDrawAttrib:(GLKVertexAttrib)attrib numberOfCoordinations:(GLint)count offset:(GLsizeiptr)offset enable:(BOOL)enable
{
    if (enable) {
        glEnableVertexAttribArray(attrib);
    }
    glVertexAttribPointer(attrib,
                          count,
                          GL_FLOAT,
                          GL_FALSE,
                          stride,
                          NULL + offset);
}

- (void)drawMode:(GLenum)mode start:(GLint)start count:(GLsizei)count
{
    glDrawArrays(mode, start, count);
}

- (void)dealloc {
    if (name != 0) {
        glDeleteBuffers(1, &name);
        name = 0;
    }
}

@end
