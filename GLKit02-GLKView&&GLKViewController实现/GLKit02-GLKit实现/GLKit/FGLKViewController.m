//
//  FGLKViewController.m
//  GLKit02-GLKit实现
//
//  Created by Fu,Sheng on 2018/11/20.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import "FGLKViewController.h"

@interface FGLKViewController ()
{
    CADisplayLink *displayLink;
}

@end

@implementation FGLKViewController
@synthesize paused = _paused;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(display)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.paused = false;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(display)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.paused = false;
    }
    return self;
}


- (void)display {
    FGLKView *view = (FGLKView *)self.view;
    [view display];
}


- (void)setPaused:(BOOL)paused {
    displayLink.paused = paused;
}

- (BOOL)isPaused {
    return displayLink.isPaused;
}

- (void)glkView:(FGLKView *)view drawInRect:(CGRect)rect {

}


- (void)viewDidLoad {
    [super viewDidLoad];
    FGLKView *view = (FGLKView *)self.view;
    view.opaque = true;
    view.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.paused = false;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.paused = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
