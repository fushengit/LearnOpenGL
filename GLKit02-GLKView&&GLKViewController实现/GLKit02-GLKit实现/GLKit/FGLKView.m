//
//  FGLView.m
//  GLKit02-GLKit实现
//
//  Created by Fu,Sheng on 2018/11/20.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import "FGLKView.h"
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/ES2/gl.h>


@interface FGLKView () {
    EAGLContext   *context;
    GLuint        defaultFrameBuffer;
    GLuint        colorRenderBuffer;
    GLint         drawableWidth;
    GLint         drawableHeight;
}
@end

@implementation FGLKView


+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)context {
    if (self = [super initWithFrame:frame]) {
        CAEAGLLayer *eagllayer = (CAEAGLLayer *)self.layer;
        eagllayer.drawableProperties = @{
                                         kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8, //用8位来保存每个像素的每个原色元素的值
                                         kEAGLDrawablePropertyRetainedBacking:@(NO) //不保留背景
                                         };
        self.context = context;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        CAEAGLLayer *eagllayer = (CAEAGLLayer *)self.layer;
        eagllayer.drawableProperties = @{
                                         kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8,
                                         kEAGLDrawablePropertyRetainedBacking:@(NO)
                                         };
    }
    return self;
}

- (void)setContext:(EAGLContext *)aContext {
    if (context != aContext) {
        [EAGLContext setCurrentContext:context];
        
        if (defaultFrameBuffer != 0) {
            glDeleteFramebuffers(1, &defaultFrameBuffer); //step 7
            defaultFrameBuffer = 0;
        }
        if (colorRenderBuffer != 0) {
            glDeleteRenderbuffers(1, &colorRenderBuffer); //step 7
            colorRenderBuffer = 0;
        }
        if (aContext) {
            context = aContext;
            [EAGLContext setCurrentContext:context];
            glGenFramebuffers(1, &defaultFrameBuffer);  //step 1
            glBindFramebuffer(GL_FRAMEBUFFER, defaultFrameBuffer);   //step 2
            
            glGenRenderbuffers(1, &colorRenderBuffer); //step 1
            glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);   //step 2
            
            // attach color renderbuffer to frame buffer , 配合Core Animation使用。
            glFramebufferRenderbuffer(GL_FRAMEBUFFER,
                                      GL_COLOR_ATTACHMENT0,
                                      GL_RENDERBUFFER,
                                      colorRenderBuffer);
            [self layoutSubviews];
        }
    }
}

- (EAGLContext *)context {
    return context;
}

- (void)display {
    [EAGLContext setCurrentContext:context];
    // 调整视口大小
    glViewport(0, 0, (GLsizei)self.drawableWidth, (GLsizei)self.drawableHeight);
    // 重新绘制
    [self drawRect:self.bounds];
    // 开始渲染renderbuffer,渲染完成后会和framebuffer交换展示在视图上
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)drawRect:(CGRect)rect {
    if (self.delegate && [self.delegate respondsToSelector:@selector(glkView:drawInRect:)]) {
        [self.delegate glkView:self drawInRect:rect];
    }
}

- (NSInteger)drawableWidth {
    GLint width;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER,
                                 GL_RENDERBUFFER_WIDTH,
                                 &width);
    return (NSInteger)width;
}

- (NSInteger)drawableHeight {
    GLint height;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER,
                                 GL_RENDERBUFFER_HEIGHT,
                                 &height);
    return (NSInteger)height;
}



-(void)layoutSubviews {
    CAEAGLLayer *eagllayer = (CAEAGLLayer *)self.layer;
    [EAGLContext setCurrentContext:context];
    // 调整视图尺寸以适应新的尺寸
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eagllayer];
    
    // 重新绑定renderbuffer
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
    
    // 检查frambuffer是否生效
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if ( status!= GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"fail to make complete frame buffer %d",status);
    }
   
}


- (void)dealloc {
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    context = nil;
}


@end
