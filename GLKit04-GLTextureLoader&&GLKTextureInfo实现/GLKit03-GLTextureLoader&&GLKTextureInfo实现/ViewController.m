//
//  ViewController.m
//  GLKit03-GLTextureLoader&&GLKTextureInfo实现
//
//  Created by Fu,Sheng on 2018/11/22.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import "ViewController.h"
#import "FVertexAttribArrayBuffer.h"
#import "FGLKTextureLoader.h"

typedef struct {
    GLKVector3 positionCoordinate;
    GLKVector2 textureCoordinate;
}SenceVertex;

static const SenceVertex verteices[] = {
    {{-0.5,0.5,0},{0,1}},
    {{-0.5,-0.5,0},{0,0}},
    {{0.5,-0.5,0},{1,0}},
    {{0.5,0.5,0},{1,1}},
};

@interface ViewController ()
{
    GLKBaseEffect *effect;
    FVertexAttribArrayBuffer *vertexBuffer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    effect = [[GLKBaseEffect alloc]init];
    effect.constantColor = GLKVector4Make(1, 1, 1, 1);
    effect.useConstantColor = true;
    
    glClearColor(0, 0, 0, 1);
    vertexBuffer = [[FVertexAttribArrayBuffer alloc] initWithStride:sizeof(SenceVertex)
                                                     namberOfVertex:sizeof(verteices)/sizeof(SenceVertex)
                                                             buffer:verteices
                                                              usage:GL_STATIC_DRAW];
    
    FGLKTextureInfo *textureInfo = [FGLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"flower"].CGImage
                                                                 options:NULL
                                                                   error:NULL];
    effect.texture2d0.name = textureInfo.name;
    effect.texture2d0.target = textureInfo.target;
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [effect prepareToDraw];
    
    [vertexBuffer prepareToDraw:GLKVertexAttribPosition
          numberOfCoordinatices:3
                         offset:offsetof(SenceVertex, positionCoordinate)
                         enable:true];
    [vertexBuffer prepareToDraw:GLKVertexAttribTexCoord0
          numberOfCoordinatices:2
                         offset:offsetof(SenceVertex, textureCoordinate)
                         enable:true];
    [vertexBuffer drawMode:GL_TRIANGLES
           startOfVerteice:0
          numberOfVerteice:4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
