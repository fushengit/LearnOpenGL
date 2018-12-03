//
//  FVertexAttribBufferArray.m
//  GLKit07-自定义纹理
//
//  Created by Fu,Sheng on 2018/12/3.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import "FVertexAttribBufferArray.h"

@interface FVertexAttribBufferArray()
{
    GLuint name;
    GLsizei stride;
}
@end

@implementation FVertexAttribBufferArray

- (instancetype)initWithStride:(GLsizei)aStride numberOfVertices:(GLuint)count buffer:(const GLvoid *)buffer usage:(GLenum)usage{
    self = [super init];
    if (self) {
        stride = aStride;
        glGenBuffers(1, &name);
        glBindBuffer(GL_ARRAY_BUFFER, name);
        glBufferData(GL_ARRAY_BUFFER,
                     stride * count,
                     buffer,
                     usage);
        
    }
    return self;
}


- (void)prepareToDraw:(GLKVertexAttrib)attribIndex numberOfCoordinates:(GLint)size offset:(GLsizeiptr)offset enable:(BOOL)enable{
    if (enable) {
        glEnableVertexAttribArray(attribIndex);
    }
    glVertexAttribPointer(attribIndex,
                          size,
                          GL_FLOAT,
                          GL_FALSE,
                          stride,
                          NULL + offset);
}


- (void)draw:(GLenum)mode start:(GLint)start numberOfVertices:(GLuint)count{
    glDrawArrays(mode, start, count);
}

- (void)dealloc {
    if (name != 0) {
        glDeleteBuffers(1, &name);
        name = 0;
    }
}

@end
