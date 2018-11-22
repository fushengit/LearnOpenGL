//
//  FVertexAttribArrayBuffer.m
//  GLKit03-GLTextureLoader&&GLKTextureInfo实现
//
//  Created by Fu,Sheng on 2018/11/22.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import "FVertexAttribArrayBuffer.h"
@interface FVertexAttribArrayBuffer()
{
    GLuint name;
    GLsizei stride;
}
@end

@implementation FVertexAttribArrayBuffer
- (instancetype)initWithStride:(GLsizei)aStride
                namberOfVertex:(GLsizei)count
                        buffer:(const GLvoid *)data
                         usage:(GLenum)usage
{
    self = [super init];
    if (self) {
        glGenBuffers(1, &name);
        glBindBuffer(GL_ARRAY_BUFFER, name);
        stride = aStride;
        glBufferData(GL_ARRAY_BUFFER,
                     stride * count,
                     data,
                     usage);
    }
    return self;
}


- (void)prepareToDraw:(GLKVertexAttrib)attrib
numberOfCoordinatices:(GLint)count
               offset:(GLsizeiptr)offset
               enable:(BOOL)enable
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

- (void)drawMode:(GLenum)mode
 startOfVerteice:(GLint)index
numberOfVerteice:(GLsizei)count {
    glDrawArrays(mode,
                 index,
                 count);
}

@end
