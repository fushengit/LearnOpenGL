//
//  FGLVertexAttribArrayBuffer.h
//  GLKit03-纹理
//
//  Created by Fu,Sheng on 2018/11/22.
//  Copyright © 2018年 shoon fu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface FGLVertexAttribArrayBuffer : NSObject
- (instancetype)initWithStride:(GLsizei)stride
              numberOfVertices:(GLsizei)count
                         bytes:(const GLvoid *)dataPtr
                         usage:(GLenum)usage;
- (void)prepareToDrawWithAttri:(GLKVertexAttrib)index
                        enable:(BOOL)enable
           numberOfCoordinates:(GLint)count
                        offset:(GLsizeiptr)offset;
- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)index
         numberOfVertices:(GLsizei)count;
@end
