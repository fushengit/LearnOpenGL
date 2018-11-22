//
//  FGLVertexAttribArrayBuffer.m
//  GLKit03-纹理
//
//  Created by Fu,Sheng on 2018/11/22.
//  Copyright © 2018年 shoon fu. All rights reserved.
//

#import "FGLVertexAttribArrayBuffer.h"


@interface FGLVertexAttribArrayBuffer(){
    GLuint name;
    GLsizei stride;
}
@end

@implementation FGLVertexAttribArrayBuffer

- (instancetype)initWithStride:(GLsizei)aStride
              numberOfVertices:(GLsizei)count
                         bytes:(const GLvoid *)dataPtr
                         usage:(GLenum)usage
{
    self = [super init];
    if (self) {
        // step1
        glGenBuffers(1, &name);
        // step2
        glBindBuffer(GL_ARRAY_BUFFER, name);
        // step3
        stride = aStride;
        glBufferData(GL_ARRAY_BUFFER,
                     stride * count,
                     dataPtr,
                     usage);
    }
    return self;
}

- (void)prepareToDrawWithAttri:(GLKVertexAttrib)index
                        enable:(BOOL)enable
           numberOfCoordinates:(GLint)count
                        offset:(GLsizeiptr)offset
{
    if (enable) {
        // step4
        glEnableVertexAttribArray(index);
    }
    // step 5
    glVertexAttribPointer(index,
                          count,
                          GL_FLOAT,
                          GL_FALSE,
                          stride,
                          NULL+offset);
}

- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)index
         numberOfVertices:(GLsizei)count
{
    // step 6
    glDrawArrays(mode, index, count);
}


- (void)dealloc {
    if (name !=0) {
        glDeleteBuffers(1, &name);
        name = 0;
    }
}
@end
