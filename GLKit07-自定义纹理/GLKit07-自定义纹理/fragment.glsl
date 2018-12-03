
uniform sampler2D uSampler0;

varying lowp vec2 vTextureCoord0;

void main()
{
    gl_FragColor = texture2D(uSampler0,vTextureCoord0);
}
