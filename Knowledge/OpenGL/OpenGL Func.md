# OpenGL

## glEnable()/glDisable()

### 名称

启用或禁用服务器端GL功能

### C规范

void **glEnable**(GLenum *cap*);

void **glDisable**(GLenum *cap*);

### 参数

#### cap

指定表示GL功能的 符号常量

### 描述

**glEnable**和**glDisable**启用和禁用各种功能。使用[glIsEnabled](https://blog.csdn.net/flycatdeng/article/details/82667251)或[glGet](https://blog.csdn.net/flycatdeng/article/details/82595295)确定任何功能的当前设置。除**GL_DITHER**(抖动)外，每个功能的初始值为**GL_FALSE**。**GL_DITHER**的初始值为**GL_TRUE**。

**glEnable**和**glDisable**都使用单个参数*cap*，它可以采用以下值之一：

#### GL_BLEND

​    如果启用，则将计算的片段颜色值与颜色缓冲区中的值混合。 请参阅[glBlendFunc](https://blog.csdn.net/flycatdeng/article/details/82664579)。

#### GL_CULL_FACE

​    如果启用，则根据窗口的坐标来剔除多边形。 请参阅[glCullFace](https://blog.csdn.net/flycatdeng/article/details/82665050)。

#### GL_DEPTH_TEST

​    如果启用，进行深度比较并更新深度缓冲区。 注意，即使存在深度缓冲区且深度掩码不为零，如果禁用深度测试，也将不会更新深度缓冲区。 请参阅[glDepthFunc](https://blog.csdn.net/flycatdeng/article/details/82667013)和[glDepthRangef](https://blog.csdn.net/flycatdeng/article/details/82667024)。

#### GL_DITHER

​    如果启用，则在将颜色组件或索引写入颜色缓冲区之前对其进行抖动。

#### GL_POLYGON_OFFSET_FILL

​    如果启用，则会将偏移添加到由光栅化生成的多边形片段的深度值。 请参阅[glPolygonOffset](https://blog.csdn.net/flycatdeng/article/details/82667293)。（常用于处理**Z-fighting**）

#### GL_SAMPLE_ALPHA_TO_COVERAGE

​    如果启用，则计算临时覆盖值，其中每个位由相应样本位置的alpha值确定。 然后，临时覆盖值与片段覆盖值进行AND运算。

#### GL_SAMPLE_COVERAGE

​    如果启用，则片段的覆盖范围与临时覆盖值进行AND运算。 如果**GL_SAMPLE_COVERAGE_INVERT**设置为**GL_TRUE**，则反转coverage值。 请参阅[glSampleCoverage](https://blog.csdn.net/flycatdeng/article/details/82667303)。

#### GL_SCISSOR_TEST

​    如果启用，则丢弃裁剪矩形之外的片段。 见[glScissor](https://blog.csdn.net/flycatdeng/article/details/82667306)。

#### GL_STENCIL_TEST

​    如果启用，将进行模板测试并更新模板缓冲区。 请参阅[glStencilFunc](https://blog.csdn.net/flycatdeng/article/details/82667324)和[glStencilOp](https://blog.csdn.net/flycatdeng/article/details/82667343)。

### 错误

#### GL_INVALID_ENUM

如果*cap*不是之前列出的值之一。