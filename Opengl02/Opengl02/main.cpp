

/*
    本节介绍一些简单图形的绘制
    
    重点：
    1.学习OpenGL绘制函数的基本构成和理解。
    2.绘制图形的的方法
    3.几种绘制方式的区别
 
    思考：
    数学上讲：点动成线，线动成面，面动成体。那么我们是否可以根据解析几何里面图像的函数来画出所有的形状图形？尝试分别画出圆形，心形，五角星等二维的图像。
 */

#include <iostream>
#include <OpenGL/gl.h>
#include <GLUT/glut.h>

/*
    OpenGL提供了一系列函数,结构一般为：gl+函数名+参数个数(绘点等需要)+表示参数类型的字母
    表示参数类型的字母有：
    s表示16位整数（OpenGL中将这个类型定义为GLshort）
    i表示32位整数（OpenGL中将这个类型定义为GLint和GLsizei）
    f表示32位浮点数（OpenGL中将这个类型定义为GLfloat和GLclampf）
    d表示64位浮点数（OpenGL中将这个类型定义为GLdouble和GLclampd）
    v表示传递的几个参数将使用指针的方式（一般情况用的是一个数组当做该函数的参数）
    需要注意的是，参数虽然可能类型不一样，但是参数值是是一样的情况下，显示的效果不影响（即参数类型在参数值一样的情况下是对绘制没有影响的）。
 */

//绘制一个矩形
void dispay1()
{
    glClear(GL_COLOR_BUFFER_BIT);
    //指定绘制的颜色是（如果不写默认是白色）
    glColor3f (1.0, 1.0, 0.0);
    //4个参数分别是二维平面矩形对角线的横纵坐标
    //通过这个可以看出来，我们绘制的坐标系用的是世界坐标系，中点默认在窗口的中心。坐标的取值范围默认是[-1,1]
    glRectf(-0.5f, -0.5f, 0.5f, 0.5f);
    glFlush();
}

/*
 绘制类型分为以下几种，可以多用几个点来分别试一试绘制类型的不同展示的效果。dispay2() 以绘制两个点为例
  以多个单个的点作图
  GL_POINTS
  点连成线作图
  GL_LINES  两个点作为一条线 每条线单个且不交叉
  GL_LINE_LOOP  每一条线收尾相连 不交叉
  GL_LINE_STRIP 交叉线
  三角形作图
  GL_TRIANGLES  单个三角形
  GL_TRIANGLE_STRIP 三角形相接
  GL_TRIANGLE_FAN   以一个点作为所有三角形的顶点作图
  四边形作图
  GL_QUADS   单个的四边形
  GL_QUAD_STRIP 四边形相接
  多边形作图
  GL_POLYGON  单个多边形
 
 注意：上面的中文解释只是助于理解，具体还是得视情况而定
 */

//通过点的绘制和点之间的连线绘制一些点，线，面
void dispay2()
{
    glClear(GL_COLOR_BUFFER_BIT);
    //这个可以用来绘制点大小，参数的单位是像素
    glPointSize(5.0f);
    //这个用来设置绘制线的粗细，参数的单位也是像素
    glLineWidth(5.0f);
    //绘制类型 GL_POINTS 多个点
    //所有绘制需要的的点必须在glbegin()和glEnd()之间，并由glBegin()函数制定绘制的类型。不在glbegin()和glEnd()之间的点绘制时忽略。
    glBegin(GL_POINTS);
    glVertex2f(0.2f, 0.2f);
    glVertex2f(0.8f, 0.8f);
    glEnd();
    glFlush();
}

int main(int argc, char** argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE|GLUT_RGB);
    glutInitWindowSize(200, 200);
    glutInitWindowPosition(100, 100);
    glutCreateWindow("opengl02");
    //给一个背景颜色（不写的话默认是无色，视觉上显示黑色）
    glClearColor(1.0, 0, 0, 0);
    glutDisplayFunc(dispay2);
    glutMainLoop();
    return 0;
}
