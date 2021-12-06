# blog_address
收集日常工作中遇到过写的不错的文章链接

# 前沿

[GMTC](https://gmtc.infoq.cn/)



# 音视频

## H264编码原理

[H264编码原理浅析](https://zhuanlan.zhihu.com/p/158392753)



# iOS

[iOS 编程规范](https://alexcode2.gitbook.io/ios-development-guidelines/)

[马蜂窝技术博客](https://my.oschina.net/u/4084220?tab=newest&catalogId=0)

[面试题](https://hit-alibaba.github.io/interview/)

[iOS中高级面试](https://blog.csdn.net/u014600626/article/details/102923706)

[OpenGL 面试](https://www.zybuluo.com/cxm-2016/note/536179)

## CoreAnimation

[ios动画](https://www.cnblogs.com/fshmjl/p/8477756.html)

## App优化

### 内存优化

[ios-crash-dump-analysis-book](https://faisalmemon.github.io/ios-crash-dump-analysis-book/zh/)

[memgraph使用](http://www.yuezyevil.com/2021/01/14/iOS%20%E5%86%85%E5%AD%98%E8%B0%83%E8%AF%95%E7%AF%87%20%E2%80%94%E2%80%94%20memgraph/)

[全平台硬件解码渲染方法与优化实践](https://www.pianshen.com/article/863064049/)

## UIKit

### CollectionView

[自定义FlowLayout](https://github.com/Tuberose621/-CollectionViewLayout-CollectionViewFlowLayout-)

## 单元测试

[XCTest单元测试](https://www.jianshu.com/p/81b10745044b)

## AVFoundation

[iOS音视频 - 掘金](https://juejin.cn/post/6844904115416334350)

## Documents

[苹果示例代码文档](https://developer.apple.com/library/archive/navigation/)

## GPUImage
[gpuimage-camera](http://www.lymanli.com/2019/06/15/ios-gpuimage-camera/)

[实际应用](https://blog.hudongdong.com/ios/539.html)

[GPUImage源码分析 -- 原理](https://www.shuzhiduo.com/A/6pdDAPVKzw/)

## OpenGL ES

[OpenGL入门](http://colin1994.github.io/archives/)


## ffmpeg
[ffmpeg集成](https://www.jianshu.com/p/ecfbebadbe55)

[ffmpeg 视频处理入门教程-沅一峰](http://www.ruanyifeng.com/blog/2020/01/ffmpeg.html)

## 自动打包

[shell 语法](https://www.jianshu.com/p/780cdac4e9a7)
[打包脚本](https://www.jianshu.com/p/bc1c38486887)

示例参考：

```shell
#!/bin/bash
# Author leeway 

#$0：当前Shell程序的文件名
#dirname $0，获取当前Shell程序的路径
#cd `dirname $0`，进入当前Shell程序的目录
#工程绝对路径
project_path=$(cd `dirname $0`; pwd)

# 工程名
workspace_name="StartShootingCamera"
# target name
project_name="startshooting"

# scheme名
scheme_name="startshooting"

# 环境
development_mode=Release

# ipa路径
project_ipa_path=/Users/meiliangjun1_vendor/Desktop/Temp/Sources/startshooting/ipa
 
DATE=`date +%Y%m%d%H%M`
#-%d_%H-%M-%S
date_to_month="$(date "+%Y-%m")"
SOURCEPATH=$( cd $project_path && pwd )
ipa_path=${project_ipa_path}/${date_to_month}
ipa_name=${scheme_name}${DATE}.ipa

#获取项目版本号
mainVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ${project_path}/${project_name}/${project_name}/Info.plist)
mainBuild=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ${project_path}/${project_name}/${project_name}/Info.plist)
appName=$(/usr/libexec/PlistBuddy -c "Print CFBundleName" ${project_path}/${project_name}/${project_name}/Info.plist)

versionString="_${mainVersion}_${mainBuild}"
#Build文件夹路径,目前Build是放在桌面
build_path=${ipa_path}/Build/${project_name}${versionString}${DATE}
#导出.ipa文件所在路径，IPAs默认在桌面
exportIpaPath=${ipa_path}/IPAs/${development_mode}/${project_name}${versionString}${DATE}

# 证书信息
exportOptionsPlistPath=${project_path}/ExportOptions.plist

echo 'ipa path: '${build_path}
echo 'exportIpaPath: '${exportIpaPath}

#打包工程
echo '/+++++++ 正在清理工程 +++++++/'
xcodebuild \
-workspace ${project_path}/${workspace_name}.xcworkspace \
-scheme ${scheme_name} \
clean -configuration ${development_mode} -quiet  || exit
echo '/+++++++ 清理完成 +++++++/'

echo '正在编译工程:'${development_mode}
xcodebuild \
archive -workspace ${project_path}/${workspace_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath ${build_path}/${workspace_name}.xcarchive  -quiet  || exit
echo '/+++++++ 编译完成 +++++++/'

echo '/+++++++ 开始ipa打包 +++++++/'
xcodebuild -exportArchive -archivePath ${build_path}/${workspace_name}.xcarchive \
-configuration ${development_mode} \
-exportPath ${exportIpaPath} \
-exportOptionsPlist ${exportOptionsPlistPath} \
-quiet || exit
# 判断IPAs内是否有ipa包
if [ -e $exportIpaPath/${appName}.ipa ]; then
echo '/+++++++ ipa包已导出 +++++++/'
open $exportIpaPath
else
echo '/+++++++ ipa包导出失败 +++++++/'
fi
 
#自动上传到蒲公英
PGYUSERKEY=b128ddd2f6941f0d386768c2c5cb8cfa
PGYAPIKEY=796970476f80701e41c4493b58d35ec7

curl -F "file=@$exportIpaPath/${appName}.ipa" \
-F "uKey=$PGYUSERKEY" \
-F "_api_key=$PGYAPIKEY" \
https://qiniu-storage.pgyer.com/apiv1/app/upload
#-F "password=sensetime2021" \

```



# GitHub

[腾讯](https://github.com/tencentyun)
[美团-旧](https://github.com/meituan)
[美团-新](https://github.com/meituan-dianping)
[阿里巴巴-(alibaba)](https://github.com/alibaba)

# WebRTC

[sdp详细解析](https://www.cnblogs.com/onlycoder/p/7297362.html)
[iOS端实现1对1音视频实时通话](https://zhuanlan.zhihu.com/p/65448600)
[GoogleWebRTC的pod仓库](http://cocoapods.org/pods/GoogleWebRTC)


# Pods

[Podfile](https://www.jianshu.com/p/8a0fd6150159)
[SDK开发及打包过程](https://juejin.im/entry/6844903796661813256)


# CMake
[CMake教程](https://aiden-dong.github.io/2019/07/20/CMake%E6%95%99%E7%A8%8B%E4%B9%8BCMake%E4%BB%8E%E5%85%A5%E9%97%A8%E5%88%B0%E5%BA%94%E7%94%A8/)

[iOS交叉编译C库](http://noxchen.com/?p=163)


# Tools

[Mac命令行提升效率](https://juejin.im/post/5b8f366e5188251f245260f2)

[如何提升搜索效率](https://zhuanlan.zhihu.com/p/42831312)

[iOS 屏幕旋转前世今生](https://wenxiangjiang.gitbooks.io/screenlayout/content/chapter3.html)

## 业余研究

#### Python 抢购

[京东抢购茅台](https://github.com/huanghyw/jd_seckill)


# Language

## C/C++/Linux/Shell

[C语言中文网](http://c.biancheng.net/c/)
[为什么这么设计系列文章](https://draveness.me/whys-the-design/)

## Swift

[Swift 中 GCD 的使用](https://juejin.im/post/6858126631760986126#heading-14)

## Web

#### Study

[Check Html](https://validator.w3.org/)
[MDN Web Docs](https://developer.mozilla.org/zh-CN/docs)


# BUG 解决方案

## iOS

### Crash分析

[了解和分析iOS Crash](https://wetest.qq.com/lab/view/404.html)

[有赞crash平台符号化实践](https://tech.youzan.com/you-zan-crashping-tai-fu-hao-hua-shi-jian/)

### XCode

[iOSDeviceSupport](https://github.com/JinjunHan/iOSDeviceSupport)

### ___gxx_personality_v0", referenced from:...

[原因：未导入libstdc++库](https://www.cnblogs.com/cocoajin/p/4744726.html)

### ___isPlatformVersionAtLeast", referenced from:的编译错误

[原因：xcode10使用了xcode11编译的库](https://ask.dcloud.net.cn/question/82853)

