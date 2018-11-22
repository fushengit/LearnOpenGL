//
//  FVertexAttribArrayBuffer.h
//  GLKit03-GLTextureLoader&&GLKTextureInfo实现
//
//  Created by Fu,Sheng on 2018/11/22.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>


@interface FVertexAttribArrayBuffer : NSObject
- (instancetype)initWithStride:(GLsizei)aStride
                namberOfVertex:(GLsizei)count
                        buffer:(const GLvoid *)data
                         usage:(GLenum)usage;

- (void)prepareToDraw:(GLKVertexAttrib)attrib
numberOfCoordinatices:(GLint)count
               offset:(GLsizeiptr)offset
               enable:(BOOL)enable;
- (void)drawMode:(GLenum)mode
 startOfVerteice:(GLint)index
numberOfVerteice:(GLsizei)count;
@end
