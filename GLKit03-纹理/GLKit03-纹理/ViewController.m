//
//  ViewController.m
//  GLKit03-纹理
//
//  Created by shoon fu on 2018/11/21.
//  Copyright © 2018 shoon fu. All rights reserved.
//

#import "ViewController.h"
#import "FGLVertexAttribArrayBuffer.h"

typedef struct {
    GLKVector3 positionCoordinate;
    GLKVector2 textureCoordinate;
}SenceVertex;

static const SenceVertex verteics[] = {
    {{-0.5,0.5,0},{0,1}},
    {{-0.5,-0.5,0},{0,0}},
    {{0.5,-0.5,0},{1,0}}
};

@interface ViewController ()
@property(nonatomic, strong) FGLVertexAttribArrayBuffer *vertexAtt;
@property(nonatomic, strong) GLKBaseEffect *effect;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    glClearColor(0, 0, 0, 1);
    // 加载顶点数组
    self.vertexAtt = [[FGLVertexAttribArrayBuffer alloc] initWithStride:sizeof(SenceVertex)
                                                       numberOfVertices:3
                                                                  bytes:verteics
                                                                  usage:GL_STATIC_DRAW];
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.useConstantColor = true;
    self.effect.constantColor = GLKVector4Make(1, 1, 1, 1);
    
    /*
     GLKTextureLoader: 用于加载一个纹理
        1. options: 如何解析加载图像数据，NULL表示默认。 也可以指示加载图像生成MIP贴图
        2. 会自动调用glTexParameteri()方法来取样和循环模式。
        3. 默认的 GL_TEXTURE_MIN_FILTER 和 GL_TEXTURE_MAG_FILTER是GL_LINEAR ，
                 GL_TEXTURE_WRAP_S 和 GL_TEXTURE_WRAP_T 是 GL_CLAMP_TO_EDGE。
        4. 当使用MIP贴图， GL_TEXTURE_MIN_FILTER 会自动被设置成 GL_LINEAR_MIPMAP_LINEAR
     
     GLKTextureInfo 封装了纹理缓存的相关信息。
        1. name: 标识。
        2. target: 指定被配置的纹理缓存类型。
     */
    GLKTextureInfo *textureInfo =  [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"flower"].CGImage
                                                                options:NULL
                                                                  error:NULL];
    self.effect.texture2d0.name = textureInfo.name;
    self.effect.texture2d0.target = textureInfo.target;
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClear(GL_COLOR_BUFFER_BIT);
    [self.effect prepareToDraw];
    [self.vertexAtt prepareToDrawWithAttri:GLKVertexAttribPosition
                                    enable:true
                       numberOfCoordinates:3
                                    offset:offsetof(SenceVertex, positionCoordinate)];;
    [self.vertexAtt prepareToDrawWithAttri:GLKVertexAttribTexCoord0
                                    enable:true
                       numberOfCoordinates:2
                                    offset:offsetof(SenceVertex, textureCoordinate)];
    [self.vertexAtt drawArrayWithMode:GL_TRIANGLES
                     startVertexIndex:0
                     numberOfVertices:3];
}

@end
