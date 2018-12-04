//
//  FProgramUnit.m
//  GLKit07-自定义纹理
//
//  Created by Fu,Sheng on 2018/12/3.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import "FProgramUnit.h"

@interface FProgramUnit()
{
    GLuint program;
}
@end

@implementation FProgramUnit

- (instancetype)initWithVertexShaderPath:(NSString *)VertexShaderPath
                      fragmentShaderPath:(NSString *)fragmentShaderPath
                          attribLocation:(NSDictionary<NSString *,NSNumber *> *)attribLocation
                         uniformLocation:(NSMutableDictionary<NSString *,NSNumber *> *)uniformLocation

{
    self = [super init];
    if (self) {
        program = glCreateProgram();
        GLuint vertexShader = [self createShader:GL_VERTEX_SHADER shaderPath:VertexShaderPath];
        GLuint fragmentShader = [self createShader:GL_FRAGMENT_SHADER shaderPath:fragmentShaderPath];
        if (fragmentShader == 0 || vertexShader == 0) {
            if (vertexShader != 0) {
                glDeleteShader(vertexShader);
            }
            if (fragmentShader != 0) {
                glDeleteShader(fragmentShader);
            }
            glDeleteProgram(program);
            return nil;
        }
        
        glAttachShader(program, vertexShader);
        glAttachShader(program, fragmentShader);
        
        for (NSString *str in attribLocation.allKeys) {
            glBindAttribLocation(program, attribLocation[str].unsignedIntValue, str.UTF8String);
        }
        
        glLinkProgram(program);
        GLint status;
        glGetProgramiv(program,
                       GL_LINK_STATUS,
                       &status);
        if (status == 0) {
            glDeleteShader(vertexShader);
            glDeleteShader(fragmentShader);
            glDeleteProgram(program);
            NSLog(@"glLinkProgram fail");
            return nil;
        }
        
        for (NSString *str in uniformLocation.allKeys) {
            uniformLocation[str] = @(glGetUniformLocation(program, str.UTF8String));
        }
        
        glDetachShader(program, vertexShader);
        glDeleteShader(vertexShader);
        glDetachShader(program, fragmentShader);
        glDeleteShader(fragmentShader);
    }
    return self;
}

- (void)use{
    glUseProgram(program);
}


- (void)dealloc {
    if (program != 0) {
        glDeleteProgram(program);
        program = 0;
    }
}

- (GLuint)createShader:(GLenum)type shaderPath:(NSString *)path
{
    NSString *shader = [NSString stringWithContentsOfFile:path
                                                 encoding:NSUTF8StringEncoding
                                                    error:NULL];
    
    if (!shader) {
        return 0;
    }
    const GLchar * shaderC = shader.UTF8String;
    // step shader 1
    GLuint name = glCreateShader(type);
    // step 2
    glShaderSource(name,
                   1,
                   &shaderC,
                   NULL);
    // step shader 3
    GLint status;
    glCompileShader(name);
    glGetShaderiv(name,
                  GL_COMPILE_STATUS,
                  &status);
    if (status == 0) {
        // step shader 4
        glDeleteShader(name);
        NSLog(@"glCompileShader fail type = %d, path = %@",true, path);
        return 0;
    }
    return name;
}

@end
