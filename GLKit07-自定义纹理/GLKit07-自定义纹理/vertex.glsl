
attribute vec4 aPosition;
attribute vec2 aTextureCoord0;

uniform mat4 mMode;

varying lowp vec2 vTextureCoord0;

void main()
{
    vTextureCoord0 = aTextureCoord0.st;
    gl_Position = mMode * aPosition;
}
