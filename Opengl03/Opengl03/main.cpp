/*
 
 
    本节主要内容：点，线，面的扩展
    本节重点：
        1.点的大小设置
        2.线的粗细设置
        3.虚线的实现原理
        4.面的正反和填充模式
        5.面的反转设置
        6.面的剔除方法
        7.面的镂空。
 */

#include <iostream>
#include <OpenGL/gl.h>
#include <GLUT/GLUT.h>
#include <math.h>

//上节的思考，这里只做一个例子。
//用点绘制出一个圆形。这种绘制方法当然效率是最低的，这里只是为了演示作用。
void dispay1()
{
    glClear(GL_COLOR_BUFFER_BIT);
    GLfloat R = 1;//半径
    GLfloat Pi = 3.1415;//圆周率
    GLint n = 100;
    glColor3f(1, 1, 0);
    //多边形绘制（自带填充效果），三角函数不多说。
    glBegin(GL_POLYGON);
    for (int i = 0; i<n; i++) {
        GLfloat x = R*cosf(2*Pi*i/n);
        GLfloat y = R*sinf(2*Pi*i/n);
        glVertex2f(x, y);
    }
    glEnd();
    glFlush();
}


/*
 点：
 因为点的默认像素是1。太小了很难发现，OpenGL的glPointSize()方法可以设置点的大小的，但是也不能设置太大，否则会出现无法预知的问题。。具体最大多少没试过。
 */
void dispay2()
{
    glClear(GL_COLOR_BUFFER_BIT);
    glColor3f(1, 1, 0);
    glPointSize(20);
    glBegin(GL_POINTS);
    glVertex2f(0, 0);
    glEnd();
    glFlush();
}


/*
 直线：
 1.线的粗细默认也是1个像素，这个和点的大小比较类似。可以通过glLineWidth()函数来实现对线粗细的设置。
 2.线也有虚实结合的效果，也就是一般说的虚线。通俗来说就是一条直线上分段显示和分段不显示，专业术语就是点画线。
    (1)可以通过glEnable(GL_LINE_STIPPLE)来设置允许虚线，glDisable(GL_LINE_STRIP)来设置不允许虚线。
    (2)虚线到底哪里该不显示，哪里该显示呢？这个就需要glLineStipple (GLint factor, GLushort pattern) 这个函数来实现。通过参数的类型我们可以发现，factor是一个32位整数；pattern是一个长度为16，又0和1组成的序列（可以看成是一个有16位二进制的数）；如果没有开启点画线会默认的把pattern=OxFFFF，factor=1；
    (3)说这么多glLineStipple (GLint factor, GLushort pattern)到底应该怎么用？从低位开始往前以一个像素为单位，如果是1则绘制，0则留空。连续的有n个1，则连续的 n*factor 个像素显示，反之有 n*factor 个像素留空。这里用一个例子来说明(这个例子来自百度百科，希望没有侵权):
        glLineStipple(1, 0x3F07);
        glEnable(GL_LINE_STIPPLE);
        此时模式为Ox3F07（二进制形式为0011111100000111），它所画出来的直线是这样的：先连续绘制3个像素，然后连续5个像素留空，再连续绘制6个像素，最后两个像素留空（注意，首先是从低位开始的）。如果factor是2，那么这个模式便被扩展为：先连续绘制6个像素，然后连续10个像素留空，再连续绘制12个像素，最后4个像素留空。
 */
void dispay3()
{
    glClear(GL_COLOR_BUFFER_BIT);
    glLineWidth(20);
    glBegin(GL_LINES);
    glVertex2f(-0.5, -0.5);
    glVertex2f(0.5, 0.5);
    glEnd();
    glFlush();
}
void dispay4()
{
    glClear(GL_COLOR_BUFFER_BIT);
    glEnable(GL_LINE_STIPPLE);
    glLineStipple(2, 0x3F07);
    glLineWidth(20);
    glBegin(GL_LINES);
    glVertex2f(-0.5, -0.5);
    glVertex2f(0.5, 0.5);
    glEnd();
    glFlush();
}

/*
    面：
    目前我们使用的是二维的画图，但是必须了解的是，在三维空间的情况下，通常一个面是有正反两面的。（麦比乌斯带这种我们就不在讨论范围之内）
    1.glFrontFace (GLenum mode) 就是用来定义面的正面， mode = GL_CCW（CounterClockWise的缩写）；则以逆时针方向为前面（正面）,mode = GL_CW（ClockWise的缩写）;则以顺时针方向为前面。
    2.glPolygonMode (GLenum face, GLenum mode) 函数用于设置面的填充模式 dispay5（） 中分别以GL_FILL，GL_LINE两种填充模式。
    3.页面的剔除需要调用 glEnable(GL_CULL_FACE) 方法，类似于画虚线也要调用该方法，参数换成GL_LINE_STIPPLE。同理，glDisable(GL_CULL_FACE)作用当然是关闭剔除功能。开启剔除功能后需要剔除哪里呢？ glCullFace (GLenum mode)提供了剔除方法，GL_BACK和GL_FRONT分别提供了剔除前面和后面的方式。
    4.和线有虚线类似面也有镂空。通过glEnable(GL_POLYGON_STIPPLE)开启镂空，glDisable(GL_POLYGON_STIPPLE)关闭镂空。glPolygonStipple (const GLubyte *mask)函数来具体执行镂空。
      （1）和虚线类似，参数mask指向一个长度128个字节的空间，表示了一个32*32的矩阵应该如何镂空。每一个字节表示从左到右的8个像素是否镂空（和虚线不一样的是这里每一个字节控制的是8个像素），和虚线一样1表示显示该像素，0表示不显示该像素。
      （2）正常情况下mask非常难记住的，我们可以通过先用系统自带的软件截取一张32*32的图片，自己用放大镜编辑黑白相间的图片（黑色对应0，白色对应1）。然后导入转换成数组即可得到mask。
 */
void dispay5()
{
    glClear(GL_COLOR_BUFFER_BIT);
    glColor3f(0, 1, 0);
    //正面填充模式
    glPolygonMode(GL_FRONT, GL_FILL);
    //背面填充模式
    glPolygonMode(GL_BACK, GL_LINE);
    //设置逆时针未正面
    glFrontFace(GL_CCW);
    //设置顺时针为正面
//    glFrontFace(GL_CW);
    //逆时针画一个正方形
    glBegin(GL_POLYGON);
    glVertex2f(-0.5, 0);
    glVertex2f(-0.5, -0.5);
    glVertex2f(0, -0.5);
    glVertex2f(0, 0);
    glEnd();
    
    //顺时针画一个正方形
    glBegin(GL_POLYGON);
    glVertex2f(0, 0);
    glVertex2f(0, 0.5);
    glVertex2f(0.5, 0.5);
    glVertex2f(0.5, 0);
    glEnd();
    
    glFlush();
}

void dispay6()
{
    glClear(GL_COLOR_BUFFER_BIT);
    glColor3f(0, 1, 0);
    glPolygonMode(GL_FRONT, GL_FILL);
    glPolygonMode(GL_BACK, GL_LINE);
    glFrontFace(GL_CCW);
    //开启剔除功能
    glEnable(GL_CULL_FACE);
    //关闭剔除功能
//    glDisable(GL_CULL_FACE);
    //剔除背面
    glCullFace(GL_BACK);
    //剔除前面
//    glCullFace(GL_FRONT);
    glBegin(GL_POLYGON);
    glVertex2f(-0.5, 0);
    glVertex2f(-0.5, -0.5);
    glVertex2f(0, -0.5);
    glVertex2f(0, 0);
    glEnd();
    glBegin(GL_POLYGON);
    glVertex2f(0, 0);
    glVertex2f(0, 0.5);
    glVertex2f(0.5, 0.5);
    glVertex2f(0.5, 0);
    glEnd();
    glFlush();
}

void dispay7()
{
    glClear(GL_COLOR_BUFFER_BIT);
    GLubyte  mask[128]=
    {
        0x00, 0x00, 0x00, 0x00,//最下面一行
        0x00, 0x00, 0x00, 0x00,
        0x03, 0x80, 0x01, 0xC0,
        0x06, 0xC0, 0x03, 0x60,
        0x04, 0x60, 0x06, 0x20,
        0x04, 0x30, 0x0C, 0x20,
        0x04, 0x18, 0x18, 0x20,
        0x04, 0x0C, 0x30, 0x20,
        0x04, 0x06, 0x60, 0x20,
        0x44, 0x03, 0xC0, 0x22,
        0x44, 0x01, 0x80, 0x22,
        0x44, 0x01, 0x80, 0x22,
        0x44, 0x01, 0x80, 0x22,
        0x44, 0x01, 0x80, 0x22,
        0x44, 0x01, 0x80, 0x22,
        0x44, 0x01, 0x80, 0x22,
        0x66, 0x01, 0x80, 0x66,
        0x33, 0x01, 0x80, 0xCC,
        0x19, 0x81, 0x81, 0x98,
        0x0C, 0xC1, 0x83, 0x30,
        0x07, 0xE1, 0x87, 0xE0,
        0x03, 0x3F, 0xFC, 0xC0,
        0x03, 0x31, 0x8C, 0xC0,
        0x03, 0x3F, 0xFC, 0xC0,
        0x06, 0x64, 0x26, 0x60,
        0x0C, 0xCC, 0x33, 0x30,
        0x18, 0xCC, 0x33, 0x18,
        0x10, 0xC4, 0x23, 0x08,
        0x10, 0x63, 0xC6, 0x08,
        0x10, 0x30, 0x0C, 0x08,
        0x10, 0x18, 0x18, 0x08,
        0x10, 0x00, 0x00, 0x08  //最上面一行
    };
    glEnable(GL_POLYGON_STIPPLE);
    glPolygonStipple(mask);
    //在左下方绘制一个有镂空效果的正方形
    glRectf(-1, -1, 0, 0);
    glDisable(GL_POLYGON_STIPPLE);
    //在右上方绘制一个无镂空效果的正方形
    glRectf(0, 0, 1, 1);
    glFlush();
}

//获取一个已知图片的mask。
GLubyte getMask()
{
    GLubyte mask[128];
    FILE * fp;
    
    return NULL;
}


int main(int argc, char ** argv) {
    glutInit(&argc, argv);
    glutInitWindowSize(64, 64);
    glutInitWindowPosition(100, 100);
    glutCreateWindow("Opengl03");
    glClearColor(1, 0, 0, 0);
    glutDisplayFunc(dispay7);
    glutMainLoop();
    return 0;
}
