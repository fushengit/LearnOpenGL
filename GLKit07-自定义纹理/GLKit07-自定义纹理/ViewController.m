//
//  ViewController.m
//  GLKit07-自定义纹理
//
//  Created by Fu,Sheng on 2018/12/3.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import "ViewController.h"
#import "FVertexAttribBufferArray.h"

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
}

- (void)update {

    
}

@end
