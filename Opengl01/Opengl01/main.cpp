//
//  main.cpp
//  Opengl01
//
//  Created by 123 on 16/12/19.
//  Copyright © 2016年 yipinbaike. All rights reserved.
//

#include <iostream>
#include <GLUT/GLUT.h>
void display()
{
    //以显示的方式设置窗体的背景颜色
    glClear (GL_COLOR_BUFFER_BIT);
    //刷新OpenGl命令队列,如果不调用此方法,那么重新绘制的图形将无法显示
    glFlush ();
}
int main(int argc, char ** argv)
{
    glutInit(&argc, argv);
    //设置指定的窗口模式：GLUT_RGB：rgb颜色模式窗口 GLUT_SINGLE：单缓存窗口(下面会介绍到)
    glutInitDisplayMode (GLUT_SINGLE | GLUT_RGB);
    //窗口的大小
    glutInitWindowSize (250, 250);
    //窗口在屏幕的位置（有默认值，可以不用设置）
    glutInitWindowPosition (100, 100);
    //窗口的名称
    glutCreateWindow ("hello");
    //用于清除缓冲区颜色，并重新设置新的颜色（背景颜色）
    glClearColor (1.0,0.0,0.0, 0.0);
    //调用一个函数,该函数会不断的被调用
    glutDisplayFunc(display);
    //用于启动程序,并使程序不断在运行不退出,即进入消息循环
    glutMainLoop();
    return 0;
}

/*
 void glutInitDisplayMode(unsigned int mode);
 GLUT_RGB 指定 RGB 颜色模式的窗口
 GLUT_RGBA 指定 RGBA 颜色模式的窗口
 GLUT_INDEX 指定颜色索引模式的窗口
 GLUT_SINGLE 指定单缓存窗口
 GLUT_DOUBLE 指定双缓存窗口
 GLUT_ACCUM 窗口使用累加缓存
 GLUT_ALPHA 窗口的颜色分量包含 alpha 值
 GLUT_DEPTH 窗口使用深度缓存
 GLUT_STENCIL 窗口使用模板缓存
 GLUT_MULTISAMPLE 指定支持多样本功能的窗口
 GLUT_STEREO 指定立体窗口
 GLUT_LUMINANCE 窗口使用亮度颜色模型
 */

/*
    总结
    1.绘图首先需要的是一个载体，也就是我们创建的窗体window
    2.创建窗体首先得定义窗体的位置，大小和窗口的模式。
    3.程序是有穷性的，函数是会结束的，窗体也会随之消失，为了让窗体继续显示，需要让程序运行不退出，进入消息循环。所以绘图当然也是需要重新绘制。
 */







