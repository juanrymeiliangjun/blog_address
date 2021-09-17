# AVFoundation

## 简介





## 原理





## AVCaptureSession





## AVVideoComposition

#### AVVideoComposition

```objective-c
//该类的构造类，提供自定义的构造类时，提供的类要遵守 AVVideoCompositing 协议
@property (nonatomic, readonly, nullable) Class<AVVideoCompositing> customVideoCompositorClass NS_AVAILABLE(10_9, 7_0);

//视频每一帧的刷新时间
@property (nonatomic, readonly) CMTime frameDuration;

//视频显示时的大小范围
@property (nonatomic, readonly) CGSize renderSize;

//视频显示范围大小的缩放比例（仅仅对 iOS 有效）
@property (nonatomic, readonly) float renderScale;

//描述视频集合中具体视频播放方式信息的集合，其是遵循 AVVideoCompositionInstruction 协议的类实例对象
//这些视频播放信息构成一个完整的时间线，不能重叠，不能间断，并且在数组中的顺序即为相应视频的播放顺序
@property (nonatomic, readonly, copy) NSArray<id <AVVideoCompositionInstruction>> *instructions;

//用于组合视频帧与动态图层的 Core Animation 的工具对象，可以为 nil 
@property (nonatomic, readonly, retain, nullable) AVVideoCompositionCoreAnimationTool *animationTool;

//直接使用一个 asset 创建一个实例，创建的实例的各个属性会根据 asset 中的所有的 video tracks 的属性进行计算并适配，所以在调用该方法之前，确保 asset 中的属性已经加载
//返回的实例对象的属性 instructions 中的对象会对应每个 asset 中的 track 中属性要求
//返回的实例对象的属性 frameDuration 的值是 asset 中 所有 track 的 nominalFrameRate 属性值最大的，如果这些值都为 0 ，默认为 30fps
//返回的实例对象的属性 renderSize 的值是 asset 的 naturalSize 属性值，如果 asset 是 AVComposition 类的实例。否则，renderSize 的值将包含每个 track 的 naturalSize 属性值
+ (AVVideoComposition *)videoCompositionWithPropertiesOfAsset:(AVAsset *)asset NS_AVAILABLE(10_9, 6_0);

//这三个属性设置了渲染帧时的颜色空间、矩阵、颜色转换函数，可能的值都在 AVVideoSetting.h 文件中定义
@property (nonatomic, readonly, nullable) NSString *colorPrimaries NS_AVAILABLE(10_12, 10_0);
@property (nonatomic, readonly, nullable) NSString *colorYCbCrMatrix NS_AVAILABLE(10_12, 10_0);
@property (nonatomic, readonly, nullable) NSString *colorTransferFunction NS_AVAILABLE(10_12, 10_0);

//该方法返回一个实例，它指定的 block 会对 asset 中每一个有效的 track 的每一帧进行渲染得到 CIImage 实例对象
//在 block 中进行每一帧的渲染，成功后应调用 request 的方法 finishWithImage:context: 并将得到的 CIImage 对象作为参数
//若是渲染失败，则应调用 finishWithError: 方法并传递错误信息

+ (AVVideoComposition *)videoCompositionWithAsset:(AVAsset *)asset
             applyingCIFiltersWithHandler:(void (^)(AVAsynchronousCIImageFilteringRequest *request))applier NS_AVAILABLE(10_11, 9_0);
```

#### AVMutableVideoComposition

`AVMutableVideoComposition` 是 `AVVideoComposition` 的可变子类，它继承父类的属性可以改变，并且新增了下面的创建方法。

```objective-c
//这个方法创建的实例对象的属性的值都是 nil 或 0，但是它的属性都是可以进行修改的
+ (AVMutableVideoComposition *)videoComposition;
```

#### AVVideoCompositionLayerInstruction

`AVVideoCompositionLayerInstruction` 是对给定的视频资源的不同播放方式进行描述的类，通过下面的方法，可以获取仿射变化、透明度变化、裁剪区域变化的梯度信息。

```objective-c
//获取包含指定时间的仿射变化梯度信息
//startTransform、endTransform 用来接收变化过程的起始值与结束值
//timeRange 用来接收变化的持续时间范围
//返回值表示指定的时间 time 是否在变化时间 timeRange 内
- (BOOL)getTransformRampForTime:(CMTime)time startTransform:(nullable CGAffineTransform *)startTransform endTransform:(nullable CGAffineTransform *)endTransform timeRange:(nullable CMTimeRange *)timeRange;

//获取包含指定时间的透明度变化梯度信息
//startOpacity、endOpacity 用来接收透明度变化过程的起始值与结束值
//timeRange 用来接收变化的持续时间范围
//返回值表示指定的时间 time 是否在变化时间 timeRange 内
- (BOOL)getOpacityRampForTime:(CMTime)time startOpacity:(nullable float *)startOpacity endOpacity:(nullable float *)endOpacity timeRange:(nullable CMTimeRange *)timeRange;

//获取包含指定时间的裁剪区域的变化梯度信息
//startCropRectangle、endCropRectangle 用来接收变化过程的起始值与结束值
//timeRange 用来接收变化的持续时间范围
//返回值表示指定的时间 time 是否在变化时间 timeRange 内
- (BOOL)getCropRectangleRampForTime:(CMTime)time startCropRectangle:(nullable CGRect *)startCropRectangle endCropRectangle:(nullable CGRect *)endCropRectangle timeRange:(nullable CMTimeRange *)timeRange NS_AVAILABLE(10_9, 7_0);
```

#### AVMutableVideoCompositionLayerInstruction

`AVMutableVideoCompositionLayerInstruction` 是 `AVVideoCompositionLayerInstruction` 的子类，它可以改变 composition 中的 track 资源播放时的仿射变化、裁剪区域、透明度等信息。

```objective-c
//这两个方法的区别在于，前者返回的实例对象的属性 trackID 的值是 track 的 trackID 值
//而第二个方法的返回的实例对象的属性 trackID 的值为 kCMPersistentTrackID_Invalid
+ (instancetype)videoCompositionLayerInstructionWithAssetTrack:(AVAssetTrack *)track;
+ (instancetype)videoCompositionLayerInstruction;
```

该类的属性表示 instruction 所作用的 track 的 ID

```objc
@property (nonatomic, assign) CMPersistentTrackID trackID;
```

设置了 trackID 后，通过下面的方法，进行剃度信息的设置：

```objc
//设置视频中帧的仿射变化信息
//指定了变化的时间范围、起始值和结束值，其中坐标系的原点为左上角，向下向右为正方向
- (void)setTransformRampFromStartTransform:(CGAffineTransform)startTransform toEndTransform:(CGAffineTransform)endTransform timeRange:(CMTimeRange)timeRange;

//设置 instruction 的 timeRange 范围内指定时间的仿射变换，该值会一直保持，直到被再次设置
- (void)setTransform:(CGAffineTransform)transform atTime:(CMTime)time;

//设置透明度的梯度信息，提供的透明度初始值和结束值应在0～1之间
//变化的过程是线形的
- (void)setOpacityRampFromStartOpacity:(float)startOpacity toEndOpacity:(float)endOpacity timeRange:(CMTimeRange)timeRange;

//设置指定时间的透明度，该透明度会一直持续到下一个值被设置
- (void)setOpacity:(float)opacity atTime:(CMTime)time;

//设置裁剪矩形的变化信息
- (void)setCropRectangleRampFromStartCropRectangle:(CGRect)startCropRectangle toEndCropRectangle:(CGRect)endCropRectangle timeRange:(CMTimeRange)timeRange NS_AVAILABLE(10_9, 7_0);

//设置指定时间的裁剪矩形
- (void)setCropRectangle:(CGRect)cropRectangle atTime:(CMTime)time NS_AVAILABLE(10_9, 7_0);
```

#### AVVideoCompositionCoreAnimationTool

在自定义视频播放时，可能需要添加水印、标题或者其他的动画效果，需要使用该类。该类通常用来协调离线视频中图层与动画图层的组合（如使用 `AVAssetExportSession` 和 `AVAssetReader` 、`AVAssetReader` 类导出视频文件或读取视频文件时），而若是在线实时的视频播放，应使用 AVSynchronizedLayer 类来同步视频的播放与动画的效果。

在使用该类时，注意动画在整个视频的时间线上均可以被修改，所以，动画的开始时间应该设置为 `AVCoreAnimationBeginTimeAtZero` ，这个值其实比 0 大，属性值 `removedOnCompletion` 应该置为 NO，以防当动画执行结束后被移除，并且不应使用与任何的 UIView 相关联的图层。

作为视频组合的后期处理工具类，主要方法如下：

```objc
//AVVideoCompositionInstruction 的属性 layerInstructions 包含的 AVVideoCompositionLayerInstruction 实例对象中应该有
//该 trackID 一致的 AVVideoCompositionLayerInstruction 实例对象，并且为性能考虑，不应使用该对象设置 transform 的变化
//在 iOS 中，CALayer 作为 UIView 的背景图层，其内容的是否能够翻转，由方法 contentsAreFlipped 决定（如果所有的图层包括子图层，该方法返回的值为 YES 的个数为奇数个，表示可以图层中内容可以垂直翻转）
//所以这里的 layer 若用来设置 UIView 的 layer 属性，或作为其中的子图层，其属性值 geometryFlipped 应设置为 YES ，这样则能够保持是否能够翻转的结果一致
+ (instancetype)videoCompositionCoreAnimationToolWithAdditionalLayer:(CALayer *)layer asTrackID:(CMPersistentTrackID)trackID;

//将放在图层 videoLayer 中的组合视频帧同动画图层 animationLayer 中的内容一起进行渲染，得到最终的视频帧
//通常，videoLayer 是 animationLayer 的子图层，而 animationLayer 则不在任何图层树中
+ (instancetype)videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:(CALayer *)videoLayer inLayer:(CALayer *)animationLayer;

//复制 videoLayers 中的每一个图层，与 animationLayer一起渲染得到最中的帧
////通常，videoLayers 中的图层都在 animationLayer 的图层树中，而 animationLayer 则不属于任何图层树
+ (instancetype)videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayers:(NSArray<CALayer *> *)videoLayers inLayer:(CALayer *)animationLayer NS_AVAILABLE(10_9, 7_0);
```

#### AVVideoCompositionValidationHandling

当我们经过编辑后得到一个视频资源 asset ，并且为该资源设置了自定义播放信息 video composition ，需要验证对于这个 asset 而言，video composition 是否有效，可以调用  `AVVideoComposition` 的校验方法。

```objc
/*
@param asset 
设置第一个参数的校验内容，设置 nil 忽略这些校验
1. 该方法可以校验 `AVVideoComposition` 的属性 instructions 是否符合要求
2. 校验 instructions 中的每个 `AVVideoCompositionInstruction` 对象的 layerInstructions 属性中的
每一个 `AVVideoCompositionLayerInstruction` 对象 trackID 值是否对应 asset 中 track 的 ID 
或 `AVVideoComposition` 的 animationTool 实例
3. 校验时间 asset 的时长是否与 instructions 中的时间范围相悖

@param timeRange 
设置第二个参数的校验内容
1. 校验 instructions 的所有的时间范围是否在提供的 timeRange 的范围内，
若要忽略该校验，可以传参数 `CMTimeRangeMake(kCMTimeZero, kCMTimePositiveInfinity)`

@param validationDelegate 
设置遵循 AVVideoCompositionValidationHandling 协议的代理类，用来处理校验过程中的报错，可以为 nil 
*/
- (BOOL)isValidForAsset:(nullable AVAsset *)asset timeRange:(CMTimeRange)timeRange validationDelegate:(nullable id<AVVideoCompositionValidationHandling>)validationDelegate NS_AVAILABLE(10_8, 5_0);
```

设置的代理对象要遵循协议 `AVVideoCompositionValidationHandling` ，该对象在实现下面的协议方法时，若修改了传递的 composition 参数，上面的校验方法则会抛出异常。

该协议提供了以下回调方法，所有方法的返回值用来确定是否继续进行校验以获取更多的错误。

```objc
//报告 videoComposition 中有无效的值
- (BOOL)videoComposition:(AVVideoComposition *)videoComposition shouldContinueValidatingAfterFindingInvalidValueForKey:(NSString *)key NS_AVAILABLE(10_8, 5_0);

//报告 videoComposition 中有时间段没有相对应的 instruction
- (BOOL)videoComposition:(AVVideoComposition *)videoComposition shouldContinueValidatingAfterFindingEmptyTimeRange:(CMTimeRange)timeRange NS_AVAILABLE(10_8, 5_0);

//报告 videoComposition 中的 instructions 中 timeRange 无效的实例对象
//可能是 timeRange 本身为 CMTIMERANGE_IS_INVALID 
//或者是该时间段同上一个的 instruction 的 timeRange 重叠
//也可能是其开始时间比上一个的 instruction 的 timeRange 的开始时间要早
- (BOOL)videoComposition:(AVVideoComposition *)videoComposition shouldContinueValidatingAfterFindingInvalidTimeRangeInInstruction:(id<AVVideoCompositionInstruction>)videoCompositionInstruction NS_AVAILABLE(10_8, 5_0);

//报告 videoComposition 中的 layer instruction 同调用校验方法时指定的 asset 中 track 的 trackID 不一致
//也不与 composition 使用的 animationTool 的trackID 一致
- (BOOL)videoComposition:(AVVideoComposition *)videoComposition shouldContinueValidatingAfterFindingInvalidTrackIDInInstruction:(id<AVVideoCompositionInstruction>)videoCompositionInstruction layerInstruction:(AVVideoCompositionLayerInstruction *)layerInstruction asset:(AVAsset *)asset NS_AVAILABLE(10_8, 5_0);
```

