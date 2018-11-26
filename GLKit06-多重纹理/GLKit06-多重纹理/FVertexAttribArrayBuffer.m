//
//  FVertexAttribArrayBuffer.m
//  GLKit06-多重纹理
//
//  Created by Fu,Sheng on 2018/11/23.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import "FVertexAttribArrayBuffer.h"

@interface FVertexAttribArrayBuffer()
{
    GLuint name;
    GLuint stride;
}
@end

@implementation FVertexAttribArrayBuffer

- (instancetype)initWithStride:(GLsizei)aStride numberOfVertices:(GLuint)count vertices:(const GLvoid *)vertices usage:(GLenum)usage
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
        if (glGetError()!=GL_NO_ERROR) {
            NSLog(@"initWithStride error");
        }
    }
    return self;
}

- (void)prepareToDraw:(GLKVertexAttrib)arrrib numberOfCoordinates:(GLint)count offset:(GLsizeiptr)offset enable:(BOOL)enable
{
    if (enable) {
        glEnableVertexAttribArray(arrrib);
    }
    glVertexAttribPointer(arrrib,
                          count,
                          GL_FLOAT,
                          GL_FALSE,
                          stride,
                          NULL + offset);
    if (glGetError()!=GL_NO_ERROR) {
        NSLog(@"prepareToDraw error");
    }
}

- (void)drawMode:(GLenum)mode start:(GLint)start count:(GLsizei)count
{
    glDrawArrays(mode, start, count);
    if (glGetError()!=GL_NO_ERROR) {
        NSLog(@"drawMode error");
    }
}


- (void)dealloc {
    if (name != 0) {
        glDeleteBuffers(1, &name);
        name = 0;
    }
}
@end
