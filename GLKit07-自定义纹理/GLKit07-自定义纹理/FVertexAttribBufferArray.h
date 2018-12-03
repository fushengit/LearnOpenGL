//
//  FVertexAttribBufferArray.h
//  GLKit07-自定义纹理
//
//  Created by Fu,Sheng on 2018/12/3.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface FVertexAttribBufferArray : NSObject
- (instancetype)initWithStride:(GLsizei)aStride numberOfVertices:(GLuint)count buffer:(const GLvoid *)buffer usage:(GLenum)usage;

- (void)prepareToDraw:(GLKVertexAttrib)attribIndex numberOfCoordinates:(GLint)size offset:(GLsizeiptr)offset enable:(BOOL)enable;

- (void)draw:(GLenum)mode start:(GLint)start numberOfVertices:(GLuint)count;
@end

