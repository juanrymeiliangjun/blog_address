# GLSL(OpenGL Shader Language)

使用 GLSL 的着色器 (shader), GLSL 是一门特殊的有着类似于 C 语言的语法，在图形管道 (graphic pipeline) 中直接可执行的 OpenGL 着色语言。着色器有两种类型 -- **顶点着色器 (Vertex Shader)** 和**片段着色器 (Fragment Shader)**. 前者是将形状转换到真实的 3D 绘制坐标中，后者是计算最终渲染的颜色和其他属性用的。

GLSL 不同于 JavaScript, 它是强类型语言，并且内置很多数学公式用于计算向量和矩阵。快速编写着色器非常复杂，但创建一个简单的着色器并不难。

### 顶点着色器(Vertex Shader)

顶点着色器操作 3D 空间的坐标并且每个顶点都会调用一次这个函数。其目的是设置 `gl_Position` 变量 -- 这是一个特殊的全局内置变量，它是用来存储当前顶点的位置：

```glsl
void main() {
	gl_Position = makeCalculationsToHaveCoordinates;
}
```

这个 `void main()` 函数是定义全局`gl_Position` 变量的标准方式。所有在这个函数里面的代码都会被着色器执行。 如果将 3D 空间中的位置投射到 2D 屏幕上这些信息都会保存在计算结果的变量中。

### 片段着色器(Fragment Shader)

片段 (或者纹理) 着色器 在计算时定义了每像素的 RGBA 颜色 — 每个像素只调用一次片段着色器。这个着色器的作用是设置 `gl_FragColor` 变量，也是一个 GLSL 内置变量：

```glsl
void main() {
	gl_FragColor = makeCalculationsToHaveColor;
}
```

计算结果包含 RGBA 颜色信息。

### 参考

[SHADER实现AE特效-旋转扭曲](https://www.freesion.com/article/1533987400/)

[Shader-js的几个思考方法](https://juejin.cn/post/6844903686037045255)

[GLSL 着色器 - mozilla](https://developer.mozilla.org/zh-CN/docs/Games/Techniques/3D_on_the_web/GLSL_Shaders)

[实时显示shader结果](https://www.shadertoy.com/)



#### AE转JSON

[ae to json](https://github.com/Jam3/ae-to-json)

[百家号基于AE生成特效](https://youle.zhipin.com/articles/9906125bcd554eeaqxB73Nq-Eg~~.html)



### 数学

[可汗学院](https://www.khanacademy.org/math/geometry-home/right-triangles-topic/intro-to-the-trig-ratios-geo/v/basic-trigonometry)