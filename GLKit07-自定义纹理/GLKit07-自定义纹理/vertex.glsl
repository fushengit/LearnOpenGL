
attribute vec4 aPosition;
attribute vec2 aTextureCoord0;

uniform mat4 mode;

varying lowp vec2 vTextureCoord0;

void main()
{
    gl_Position = mode * aPosition;
    vTextureCoord0 = aTextureCoord0.st;
}
