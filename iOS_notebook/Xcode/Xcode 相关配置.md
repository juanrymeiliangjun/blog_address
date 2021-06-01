# Xcode 管理

## Xcode 选项配置

#### Search Path配置

###### 添加Bundle资源文件

在主工程中添加bundle、static library

1. 创建新target(macOS 中的bundle)

2. 修改baseSDK，并在static lib中添加对bundle的关联

3. 将lib添加至main工程，并将bundle直接拖至main工程中的“Copy Bundle Resources”

4. 工程中直接使用，例：

   ```objective-c
   + (NSBundle *)bundleWithName:(NSString *)bundleName {
       if(bundleName.length == 0) {
           return nil;
       }
       NSString *path = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
       NSAssert([NSBundle bundleWithPath:path], @"not found bundle");
       return  [NSBundle bundleWithPath:path];
   }
   ```

[Resource Bundles & Static Library in iOS](https://09mejohn.medium.com/resource-bundles-in-ios-static-library-beba3070fafd)

###### Header Search Paths

位置：Xcode -> Target -> BuildSettings 中的 **Search Paths**

###### 参考

[Xcode Search Paths 选项配置【简书】](https://www.jianshu.com/p/d41e05e6d9fa)

##### 扩展

1、c / c++ 头文件引用问题

- include <> 引用编译器的类库路径下的头文件
- include “” 引用工程目录的相对路径的头文件

include 是编译指令，在编译时，编译器会将相对路径替换成绝对路径，因此，头文件绝对路径:**绝对路径 = 搜索路径 + 相对路径**

- Xcode Build Settings 下 Search Paths设置搜索路径，Header Search Paths:头文件搜索路径设置

```jsx
$(SRCROOT) 和 $(PROJECT_DIR) 都指xxx.xcodeproj所在的父目录
```

例如：引用工程testDemo/scr/test.h 头文件，

**注意：**

- **如果在Header Search Paths中添加`$(SRCROOT)/scr`，那么头文件引用直接引用 `include "test.h"`**
- **如果在Header Search Paths中添加`$(SRCROOT)/`，那么头文件引用直接引用 `include "scr/test.h"`**

一般工作中我们最好都使用相对路径，这样在共同开发项目时，防止发生路径错误问题。
 Library / Header Search Paths中写法：

> $(SRCROOT) / 当前工程名字 / 需要包含头文件所在文件夹

2、$(inherited)
 项目的`Framework Search Paths`添加`$(inherited)`参数会从`PROJECT -> Build Settings -> Framework Search Paths`里面的路径会被其继承，没有的话不会继承。所以一个项目里面有多个target，使用到了同一个库(Library或Framework)那么为了方便我们可以在target添加继承参数，并且PROJECT统一中添加库的路径。

3、`non-recursive`：默认路径设置，不遍历该目录。
    `recursive`：遍历该目录，如果路径的属性为`recursive`，那么编译的时候在找库的路径的时候，会遍历该目录下的所有子目录的库文件。

4、在`Other Linker Flags`中加入`-ObjC`或者`-all_load`或者`-force_load`
    在ios开发中，我们经常会使用到第三方的一些静态库,导入第三方类库运行程序后你会发现,编译时可以正常编译但是运行时会app会闪退,报出

```undefined
selector not recognized的错误
```

一般的第三方库的开发文档中都会写出这种问题的解决方法,在`Other Linker Flags`中加入`-ObjC`或者`-all_load`或者`-force_load`这样的解决方法。

- -ObjC
   一般这个参数足够解决前面提到的问题,这个flag告诉链接器把库中定义的Objective-C类和Category都加载进来。这样编译之后的app会变大,因为加载了很多不必要的文件而导致可执行文件变大。但是如果静态库中有类和category的话只有加入这个flag才行,但是Objc也不是万能的,当静态库中只有分类而没有类的时候,Objc就失效了,这就需要使用-all_load或者-force_load了。

- -all_load
   -all_load会强制链接器把目标文件都加载进来，即使没有objc代码。但是这个参数也有一个弊端,那就是你使用了不止一个静态库文件，那么你很有可能会遇到ld: duplicate symbol错误，因为不同的库文件里面可能会有相同的目标文件 这里会有两种方法解决 1:用命令行就行拆包. 2:就是用下面的这个参数
- -force_load
   这个flag所做的事情跟-all_load其实是一样的，只是-force_load需要指定要进行全部加载的库文件的路径，这样的话，你就只是完全加载了一个库文件，不影响其余库文件的按需加载



### BUG

##### library not found for -lXXX

1. 引入的库路径不正确。方法：build setting中搜索 path 找到 framework path、library path、header path查看相应库路径是否正确
2. other linker flag。方案：删除相应的库，包括上面的 -framework 字段
3. pod 引入的时候出现，可能是pod的问题，可以清除再重新 pod install
4. debug 时没有问题，但releas模式下出现，且是pod管理的时候，可能是__静态库支持的指令集问题__。方案：取消默认的指令集，修改“architectures”为：x86_64 arm64 arm64e等。

##### command ld failed with a nonzero exit code

1. 当删除一些不用说SDK的时候，代码删除干净了，可能配置中残存，只要全局搜索删除的SDK就可以找到
2. 由于第一种情况的发生，会找到Build Settings - Other Linker Flags中
3. 由于第二种情况，不知道-framework和SDK名称是成对出现的，就会出现一样问题的报错，只是提示信息不一样
4. debug 模式下可行，在 release 模式下无法编译，则说明在 build 的时候没有生成对应的静态库。我这边遇到情况是 __编译指令问题__，方案：取消默认的指令集，修改“architectures”为：x86_64 arm64 arm64e等。

