//
//  ViewController.m
//  GLKit07-自定义纹理
//
//  Created by Fu,Sheng on 2018/12/3.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import "ViewController.h"
#import "FVertexAttribBufferArray.h"
#import "FProgramUnit.h"

typedef struct {
    GLKVector3 positionCoordinate;
    GLKVector2 textureCoordinate;
}SenceVertix;


static SenceVertix vertices[] = {
    { {-0.5,0.5,0.5}, {0,1} },  //前
    { {-0.5,-0.5,0.5}, {0,0} },
    { {0.5,-0.5,0.5}, {1,0} },
    { {0.5,-0.5,0.5}, {1,0} },
    { {0.5,0.5,0.5}, {1,1} },
    { {-0.5,0.5,0.5}, {0,1} },
    
    
    { {-0.5,0.5,-0.5}, {0,1} },  //后
    { {-0.5,-0.5,-0.5}, {0,0} },
    { {0.5,-0.5,-0.5}, {1,0} },
    { {0.5,-0.5,-0.5}, {1,0} },
    { {0.5,0.5,-0.5}, {1,1} },
    { {-0.5,0.5,-0.5}, {0,1} },
    
    
    { {-0.5,0.5,-0.5}, {0,1} },  // 左
    { {-0.5,-0.5,-0.5}, {0,0} },
    { {-0.5,-0.5,0.5}, {1,0} },
    { {-0.5,-0.5,0.5}, {1,0} },
    { {-0.5,0.5,0.5}, {1,1} },
    { {-0.5,0.5,-0.5}, {0,1} },
    
    { {0.5,0.5,-0.5}, {0,1} },  // 右
    { {0.5,-0.5,-0.5}, {0,0} },
    { {0.5,-0.5,0.5}, {1,0} },
    { {0.5,-0.5,0.5}, {1,0} },
    { {0.5,0.5,0.5}, {1,1} },
    { {0.5,0.5,-0.5}, {0,1} },
    
    
    { {-0.5,0.5,0.5}, {0,1} },  //上
    { {-0.5,0.5,-0.5}, {0,0} },
    { {0.5,0.5,-0.5}, {1,0} },
    { {0.5,0.5,-0.5}, {1,0} },
    { {0.5,0.5,0.5}, {1,1} },
    { {-0.5,0.5,0.5}, {0,1} },
    
    { {-0.5,-0.5,0.5}, {0,1} },  //下
    { {-0.5,-0.5,-0.5}, {0,0} },
    { {0.5,-0.5,-0.5}, {1,0} },
    { {0.5,-0.5,-0.5}, {1,0} },
    { {0.5,-0.5,0.5}, {1,1} },
    { {-0.5,-0.5,0.5}, {0,1} },
};

@interface ViewController ()
{
    GLKBaseEffect *effect;
    FVertexAttribBufferArray *bufferArray;
    FProgramUnit *program;
    NSMutableDictionary<NSString *,NSNumber *> *uniformDict;
    GLKMatrix4 modeMat;
    float radians;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [EAGLContext setCurrentContext:view.context];
    
    glClearColor(0, 0, 0, 1);
    
    bufferArray = [[FVertexAttribBufferArray alloc] initWithStride:sizeof(SenceVertix)
                                                  numberOfVertices:sizeof(vertices)/sizeof(SenceVertix)
                                                            buffer:vertices
                                                             usage:GL_STATIC_DRAW];
    effect = [[GLKBaseEffect alloc] init];
    effect.useConstantColor = true;
    effect.constantColor = GLKVector4Make(1, 1, 1, 1);
    
    GLKTextureInfo *info = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"flower"].CGImage
                                                        options:@{GLKTextureLoaderOriginBottomLeft : @(true)}
                                                          error:NULL];
    
    effect.texture2d0.target = info.target;
    effect.texture2d0.name = info.name;
    
    uniformDict = [@{
                    @"mMode": @(0),
                    @"uSampler0":@(0)
                    } mutableCopy];
    program = [[FProgramUnit alloc] initWithVertexShaderPath:[[NSBundle mainBundle]pathForResource:@"vertex" ofType:@"glsl"]
                                          fragmentShaderPath:[[NSBundle mainBundle]pathForResource:@"fragment" ofType:@"glsl"]
                                              attribLocation:@{
                                                               @"aPosition":@(GLKVertexAttribPosition),
                                                               @"aTextureCoord0":@(GLKVertexAttribTexCoord0),
                                                               }
                                             uniformLocation:uniformDict];
    modeMat = GLKMatrix4Identity;
    radians = M_PI/360;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [effect prepareToDraw];
    [bufferArray prepareToDraw:GLKVertexAttribPosition
           numberOfCoordinates:3
                        offset:offsetof(SenceVertix, positionCoordinate)
                        enable:true];
    [bufferArray prepareToDraw:GLKVertexAttribTexCoord0
           numberOfCoordinates:2
                        offset:offsetof(SenceVertix, textureCoordinate)
                        enable:true];
    [bufferArray draw:GL_TRIANGLES
                start:0
     numberOfVertices:sizeof(vertices)/sizeof(SenceVertix)];
    
    [program use];
    glUniform1i(uniformDict[@"uSampler0"].unsignedIntValue, 0);
    glUniformMatrix4fv(uniformDict[@"mMode"].unsignedIntValue, 1, GL_FALSE, modeMat.m);
    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertices)/sizeof(SenceVertix));
}

- (void)update {
    modeMat = GLKMatrix4Rotate(modeMat, radians, 1, 0, 0);
}

@end
