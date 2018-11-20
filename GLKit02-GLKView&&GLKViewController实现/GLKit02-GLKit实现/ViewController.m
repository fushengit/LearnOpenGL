//
//  ViewController.m
//  GLKit02-GLKit实现
//
//  Created by Fu,Sheng on 2018/11/20.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>
typedef struct {
    GLKVector3 positionCoords;
}SenceVertex;

@interface ViewController ()
{
    GLuint vertexID;
    GLKBaseEffect *effect;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    FGLKView *view = (FGLKView *)self.view;

    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [EAGLContext setCurrentContext:view.context];
    glClearColor(0, 0, 0, 1);

    effect = [[GLKBaseEffect alloc] init];
    effect.useConstantColor = true;
    effect.constantColor = GLKVector4Make(1, 1, 1, 1);
    
    static const SenceVertex vertex[] = {
        {{-0.5,0,0}},
        {{0,0.5,0}},
        {{0.5,0.0}}
    };
    
    glGenBuffers(1, &vertexID);
    glBindBuffer(GL_ARRAY_BUFFER, vertexID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertex), vertex, GL_STATIC_DRAW);
}



- (void)glkView:(FGLKView *)view drawInRect:(CGRect)rect {
    [effect prepareToDraw];
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SenceVertex),
                          NULL);
    glDrawArrays(GL_TRIANGLES, 0, 3);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
