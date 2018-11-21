//
//  ViewController.m
//  GLKit03-纹理
//
//  Created by shoon fu on 2018/11/21.
//  Copyright © 2018 shoon fu. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
     当出现多个纹素对应一个片元
     GL_TEXTURE_MIN_FILTER 表示多个纹理对应一个片元
     */
    // GL_LINEAR  使用线性插值法来混合颜色得到片元的颜色。
    // 效果：当两个纹素例如黑白色，线性差值得到灰色，则片元颜色是灰色。
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    // GL_NEAREST 使用最近的一个纹素颜色。
    // 效果：当两个纹素例如黑白色，使用片元U,V坐标最近的纹素的颜色，则片元色可能是白色，也可能是黑色。
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    /*
     当出现多个片元对应一个纹素
     GL_TEXTURE_MAG_FILTER 表示多个片元对应一个纹素
     */
    // GL_LINEAR 会混合附近的纹素的颜色来计算片元的颜色
    // 效果： 放大纹理的效果，会有模糊的感觉。
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    // GL_NEAREST 会使用y片元U,V坐标最接近的颜色
    // 效果： 放大纹理的效果，有点像素化的感觉。
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    

    //GL_TEXTURE_WRAP_S 当U坐标不在S范围内
    // GL_CLAMP_TO_EDGE 取纹理边缘的纹素
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    // GL_REPEAT 重复的渲染S坐标范围
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    
    //GL_TEXTURE_WRAP_T 当V坐标不在T范围内
    // GL_CLAMP_TO_EDGE 取纹理边缘的纹素
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    // GL_REPEAT 重复的渲染S坐标范围
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
}


@end
