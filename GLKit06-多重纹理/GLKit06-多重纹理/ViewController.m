//
//  ViewController.m
//  GLKit06-多重纹理
//
//  Created by Fu,Sheng on 2018/11/23.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import "ViewController.h"
#import "FVertexAttribArrayBuffer.h"

typedef struct {
    GLKVector3 positionCoordinate;
    GLKVector2 textureCoordinate0;
    GLKVector2 textureCoordinate1;
}SenceVertex;

static const SenceVertex vertices[] = {
    {
        {-1,1,0},{0,1},{0,0.5}
    },
    {
        {-1,-1,0},{0,0},{0,0}
    },
    {
        {1,-1,0},{1,0},{0.5,0}
    },
    {
        {1,1,0},{1,1},{0.5,0.5}
    },
    {
        {-1,1,0},{0,1},{0,0.5}
    },
    {
        {1,-1,0},{1,0},{0.5,0}
    }
};

@interface ViewController ()
{
    FVertexAttribArrayBuffer *verticesArrayBuffer;
    GLKBaseEffect *effect;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    glClearColor(0, 0, 0, 1);
    verticesArrayBuffer = [[FVertexAttribArrayBuffer alloc] initWithStride:sizeof(SenceVertex)
                                                          numberOfVertices:sizeof(vertices)/sizeof(SenceVertex)
                                                                  vertices:vertices
                                                                     usage:GL_STATIC_DRAW];
    GLKTextureInfo *texture0 = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"leaves.gif"].CGImage
                                                            options:@{GLKTextureLoaderOriginBottomLeft:@(true)}
                                                              error:NULL];
    GLKTextureInfo *texture1 = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"beetle.png"].CGImage
                                                            options:@{GLKTextureLoaderOriginBottomLeft:@(true)}
                                                              error:NULL];
    
    effect = [[GLKBaseEffect alloc] init];
    effect.constantColor = GLKVector4Make(1, 1, 1, 1);
    effect.useConstantColor = true;
    
    effect.texture2d0.name = texture0.name;
    effect.texture2d0.target = texture0.target;
    
    effect.texture2d1.name = texture1.name;
    effect.texture2d1.target = texture1.target;
    // 相当于 glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
    effect.texture2d1.envMode = GLKTextureEnvModeDecal;
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClear(GL_COLOR_BUFFER_BIT);
    [effect prepareToDraw];
    [verticesArrayBuffer prepareToDraw:GLKVertexAttribPosition
                   numberOfCoordinates:3
                                offset:offsetof(SenceVertex, positionCoordinate)
                                enable:true];
    [verticesArrayBuffer prepareToDraw:GLKVertexAttribTexCoord0
                   numberOfCoordinates:2
                                offset:offsetof(SenceVertex, textureCoordinate0)
                                enable:true];
    [verticesArrayBuffer prepareToDraw:GLKVertexAttribTexCoord1
                   numberOfCoordinates:2
                                offset:offsetof(SenceVertex, textureCoordinate1)
                                enable:true];

    [verticesArrayBuffer drawMode:GL_TRIANGLES
                            start:0
                            count:sizeof(vertices)/sizeof(SenceVertex)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
