//
//  ViewController.m
//  GLKit05-透明度&&混合
//
//  Created by Fu,Sheng on 2018/11/23.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import "ViewController.h"
#import "FGLKVertexAttribArrayBuffer.h"

typedef struct {
    GLKVector3 positionCoordinate;
    GLKVector2 textureCoordinate;
}SenceVertex;

static const SenceVertex verteices[] = {
    {{-0.5,0.5,0},{0,1}},
    {{-0.5,-0.5,0},{0,0}},
    {{0.5,-0.5,0},{1,0}},
    {{0.5,0.5,0},{1,1}},
    {{-0.5,0.5,0},{0,1}},
    {{0.5,-0.5,0},{1,0}},
};

@interface ViewController ()
{
    GLKBaseEffect *effect;
    GLKTextureInfo *textureInfo0;
    GLKTextureInfo *textureInfo1;
    FGLKVertexAttribArrayBuffer *vertexBuffer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    glClearColor(0, 0, 0, 1);
    effect = [[GLKBaseEffect alloc] init];
    effect.constantColor = GLKVector4Make(1, 1, 1, 1);
    effect.useConstantColor = true;
    
    textureInfo0 = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"leaves.gif"].CGImage
                                                options:@{GLKTextureLoaderOriginBottomLeft:@(true)} //命令GLKTextureLoader垂直翻转图像数据，这个翻转可以抵消图像的原点和OpenGL ES标准原点之间的差异。
                                                  error:NULL];
    textureInfo1 = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"beetle.png"].CGImage
                                                options:@{GLKTextureLoaderOriginBottomLeft:@(true)}
                                                  error:NULL];
    vertexBuffer = [[FGLKVertexAttribArrayBuffer alloc] initWithStride:sizeof(SenceVertex)
                                                     numberOfVerteices:sizeof(verteices)/sizeof(SenceVertex)
                                                             verteices:verteices
                                                                 usage:GL_STATIC_DRAW];
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClear(GL_COLOR_BUFFER_BIT);
    [vertexBuffer prepareToDrawAttrib:GLKVertexAttribPosition
                numberOfCoordinations:3
                               offset:offsetof(SenceVertex, positionCoordinate)
                               enable:true];
    [vertexBuffer prepareToDrawAttrib:GLKVertexAttribTexCoord0
                numberOfCoordinations:2
                               offset:offsetof(SenceVertex, textureCoordinate)
                               enable:true];
    
    // draw first texture
    effect.texture2d0.name = textureInfo0.name;
    effect.texture2d0.target = textureInfo0.target;
    [effect prepareToDraw];
    [vertexBuffer drawMode:GL_TRIANGLES start:0 count:sizeof(verteices)/sizeof(SenceVertex)];
    
    // draw second texture
    effect.texture2d0.name = textureInfo1.name;
    effect.texture2d0.target = textureInfo1.target;
    [effect prepareToDraw];
    [vertexBuffer drawMode:GL_TRIANGLES start:0 count:sizeof(verteices)/sizeof(SenceVertex)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
