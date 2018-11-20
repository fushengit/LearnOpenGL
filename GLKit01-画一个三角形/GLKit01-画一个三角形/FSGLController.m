//
//  FSGLController.m
//  GLKit01-画一个三角形
//
//  Created by Fu,Sheng on 2018/11/20.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import "FSGLController.h"


typedef struct {
    GLKVector3 positionCoords;
}SenceVertex;

@interface FSGLController ()
{
    GLuint vertexID;
    GLKBaseEffect *effect;
}

@end

@implementation FSGLController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [EAGLContext setCurrentContext:view.context];
    
    //GLKBaseEffect 是为了生成shader language，让我们自己不用写，简化了OpenGL ES操作。
    effect = [[GLKBaseEffect alloc] init];
    effect.useConstantColor = GL_TRUE; // 允许颜色填充
    effect.constantColor = GLKVector4Make(1, 1, 1, 1); //颜色rgba
    
    static const SenceVertex vertices[] = {
        {{-0.5,0,0}},
        {{0,0.5,0}},
        {{0.5, 0, 0}}
    };
    
    glClearColor(0, 0, 0, 1);
    // step 1
    glGenBuffers(1, &vertexID);
    // step 2
    glBindBuffer(GL_ARRAY_BUFFER, vertexID);
    // step 3
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}



- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //准备好当前OpenGL ES上下文，以便为了使用effect的属性和生成的shader language。
    [effect prepareToDraw];
    
    // 当前缓存只有像素渲染颜色缓存，如果还有其他的缓存也需要清理。
    glClear(GL_COLOR_BUFFER_BIT);
    
    //step 4
    glEnableVertexAttribArray(GLKVertexAttribPosition);  //启动顶点缓存。
    
    //step 5
    glVertexAttribPointer(GLKVertexAttribPosition, //解释当前绑定的缓存包含的是位置信息
                          3, //顶点有3个部分
                          GL_FLOAT, //每个部分的类型
                          GL_FALSE, //每个部分的类型是否改变
                          sizeof(GLKVector3), //步幅：每个顶点需要的字节。
                          NULL); //从开始位置开始渲染
    
    glDrawArrays(GL_TRIANGLES,  //以三角形的方式渲染
                 0, //开始渲染顶点的位置
                 3); //需要渲染顶点的数量
}

- (void)dealloc {
    // step 7
    glDeleteBuffers(1, &vertexID);
    vertexID = 0;
    [EAGLContext setCurrentContext:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
