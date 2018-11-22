## GLTextureLoader && GLKTextureInfo 实现
- 纹理缓存：纹理缓存和其他前面讨论的缓存具有相同的步骤。首先使用`glGenTextures()`函数生成一个纹理标识符；然后`glBindTexture()`函数将其绑定到当前上下文；最后`glTeximage2D()`赋值图像数据来初始化纹理缓存内容。

