//
//  main.cpp
//  OpenGL01(你好,窗口)
//
//  Created by 123 on 17/6/14.
//  Copyright © 2017年 MakeKeyReuseable. All rights reserved.
//

#include <iostream>
//这里需要注意头文件导入顺序，否则编译不能通过
#include "glew.h"
#include "glfw3.h"


/*
    使用简介
 1> GLFW是在openGL里建立窗口用的。跟GLUT/freeglut类似。
 2> GLEW是用来管理OpenGL的函数指针的
 3> openGL都是跟着驱动来的。只要装了显卡驱动，就会有openGL。
 4> 一般来说假如用来开发的话，GLFW+GLEW+openGL就够用了。GLEW是用来智能载入很多openGL扩展函数(extensions)的。
 5> 编译的时候先载入openGL，然后是GLEW，最后是GLFW。假如是windows的话，也许还需要gdi32。 g++ -Wall -g main.cpp -lglfw -lglew32 -lopengl32 之类的。
 */



/*! @brief The function signature for keyboard key callbacks.
 *
 *  This is the function signature for keyboard key callback functions.
 *
 *  @param[in] window The window that received the event.
 *  @param[in] key The [keyboard key](@ref keys) that was pressed or released.
 *  @param[in] scancode The system-specific scancode of the key.
 *  @param[in] action `GLFW_PRESS`, `GLFW_RELEASE` or `GLFW_REPEAT`.
 *  @param[in] mods Bit field describing which [modifier keys](@ref mods) were
 *  held down.
 *
 *  @sa @ref input_key
 *  @sa glfwSetKeyCallback
 *
 *  @since Added in version 1.0.
 *  @glfw3 Added window handle, scancode and modifier mask parameters.
 *
 *  @ingroup input
 */
//GLFW会在合适的时候调用它,并不是因为glfwPollEvents 的触发
//window：当前的窗口 key：按下的键 action：按下还是释放 mods：是否有Ctrl、Shift、Alt、Super等按钮的操做
//这里我们监听到了 键盘 esc 被按下去了，然后将windowshouldclose 设置成TRUE，让引擎结束。
void KeyCallback(GLFWwindow* window,int key,int scancode,int action,int mods){
    if (key==GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, GL_TRUE);
    }
}

//1>为什么需要清空屏幕？
//每一个新的渲染开始的时候我们通常是希望清一下屏，否则我们总是能看见上一次的渲染结果。
void clearWindow(){
    //设置一个颜色来清空屏幕
    glClearColor(1, 0.2, 0.2, 1);
    //清空函数,目前我们仅仅指向清空颜色
    //可能的缓冲位有GL_COLOR_BUFFER_BIT，GL_DEPTH_BUFFER_BIT和GL_STENCIL_BUFFER_BIT。
    glClear(GL_COLOR_BUFFER_BIT);
}


int main(int argc, const char * argv[]) {
    
    //1>初始化glfw并设置
    //实例化glfw
    if (glfwInit()!=GLFW_TRUE) {
        std::cout<<"初始化glfw失败"<<std::endl;
        return -1;
    }
    //配置glfw
    //主版本号设置
    //这里需要注意的是，我们的主次版本号是根据OpenGL来的，目前我们用的是2.1版本(目前大部分教程都是针对3.3以上的)，所以设置主次版本应该以OpenGL版本来，而不是glfw的版本
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 2);
    //次版本号设置
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 1);
    //设置不可改变大小
    glfwWindowHint(GLFW_RESIZABLE, GL_FALSE);
    
    //2>窗口设置并设置
    //创建窗口对象
    //GLFWwindow* glfwCreateWindow(int width, int height, const char* title, GLFWmonitor* monitor, GLFWwindow* share)
    //参数依次为：窗口的宽，窗口的高，窗口的title，未知，未知。
    GLFWwindow * window = glfwCreateWindow(800, 600, "hello window", nullptr, nullptr);
    if (window==nullptr) {
        std::cout<<"初始化窗口失败"<<std::endl;
        return -1;
    }
    //通知glfw将窗口的上下文设置成当前线程的主上下文
    glfwMakeContextCurrent(window);
    
    //3>glew设置并设置
    //glew管理OpenGL的函数指针。glewExperimental设置成TRUE是为了让glew管理OpenGL函数指针的时候更多的使用现代化的技术，如果设置成FALSE可能会在使用OpenGL核心模式时出现问题。
    glewExperimental = GL_TRUE;
    if (glewInit()!=GLEW_OK) {
        std::cout<<"初始化glew失败"<<std::endl;
        return -1;
    }
    
    //4>视口设置viewport（告诉OpenGL渲染的窗口的尺寸大小，及渲染的位置。即：设置窗口的维度）
    //获取窗口大小
    int width,height;
    glfwGetFramebufferSize(window, &width, &height);
    //给视口视图设置位置及其大小
    //glViewport (GLint x, GLint y, GLsizei width, GLsizei height)
    //x,y 表示视口视图相对于窗口的位置(0,0)表示在左下角；width，height是视口视图的宽高，这里我们从窗口获取大小而不直接用窗口的800*600 是为了让他能在高的DPI屏幕上（例如Apple的视网膜显示屏）也能正常工作
    //当然，我们也可以设置宽高小一点 这样在窗口上就会小一点显示
    //OpenGL的坐标范围是【-1，1】，对应的范围映射的坐标是【0，800】，【0，600】
    glViewport(0, 0, width, height);
    
    //5>注册我们函数回调
    glfwSetKeyCallback(window, KeyCallback);
    
    //6>准备引擎。目的是为了函数能够不断的绘制并能接收用户输入。而不是渲染了一次就程序退出关闭窗口了
    while (!glfwWindowShouldClose(window)) {
        //检查有没有什么事件被触发（键盘，鼠标等），然后调用对应的回到函数
        glfwPollEvents();
        
        
        //7>这里就是我们最终要的渲染指令了
        //这里我们写一个自定义颜色清空屏幕测试
        clearWindow();
        
        //交换颜色缓冲。
        //为什么使用交换颜色缓冲?
        //应用程序使用单缓冲绘图时可能会产生图像闪烁的问题，因为图像是从左到右，由上到下逐像素绘制而成，不是一瞬间就展示给用户。所以我们通常使用的是双缓冲渲染，前缓冲保存着最终渲染好的图像用于窗口显示，而渲染指令都会在后缓冲上绘制，当所有的渲染指令完成以后我们将前后缓冲交换（swap），这样图像就显示出来了。
        glfwSwapBuffers(window);
    }
    
    //6>当循环结束后，我们需要释放glfw的内存
    glfwTerminate();
    return 0;
}



