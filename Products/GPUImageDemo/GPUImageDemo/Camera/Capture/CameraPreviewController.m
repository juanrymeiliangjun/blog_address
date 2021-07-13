//
//  CameraPreviewController.m
//  GPUImageDemo
//
//  Created by meiliangjun1_vendor on 2021/4/6.
//  Copyright © 2021 meiliangjun1_vendor. All rights reserved.
//

#import "CameraPreviewController.h"

#import <AVFoundation/AVFoundation.h>
#import <GPUImage/GPUImageFramework.h>

// camera focus color: #f3ca7e

float const SUN_LINE_HALF_HEIGHT = 50.0;

@interface CameraPreviewController ()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDevice *iDevice;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, weak) UIImageView *sunIV;
@property (nonatomic, weak) UIImageView *focusIV;
@property (nonatomic, weak) UIView *sunLineView;

@end

@implementation CameraPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AVAuthorizationStatus cameraStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (cameraStatus == AVAuthorizationStatusAuthorized) {
        [self setupCamera];
    } else if (cameraStatus == AVAuthorizationStatusNotDetermined) {
        __weak __typeof(self)weakSelf = self;
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [weakSelf setupCamera];
            }
        }];
    }
    
    [self sunLineView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换" style:UIBarButtonItemStyleDone target:self action:@selector(toggleCamera:)];
}

- (void)toggleCamera:(id)sender {
    AVCaptureDevicePosition position = (self.iDevice.position == AVCaptureDevicePositionFront) ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
    
    NSArray<AVCaptureDeviceType> *deviceType = @[AVCaptureDeviceTypeBuiltInWideAngleCamera];
    AVCaptureDeviceDiscoverySession *videoDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:deviceType mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
    
    NSArray<AVCaptureDevice *> *devices = [videoDeviceDiscoverySession devices];

    AVCaptureDevice *videoDevice = nil;//= [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            videoDevice = device;
            break;
        }
    }
    
    NSParameterAssert( videoDevice != nil );
    self.iDevice = videoDevice;
    
    [_captureSession beginConfiguration];
    
    for (AVCaptureInput *input in self.captureSession.inputs) {
        if ([input isKindOfClass:[AVCaptureDeviceInput class]]) {
            [self.captureSession removeInput:input];
        }
    }
    
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.iDevice error:nil];
    if ([_captureSession canAddInput:videoDeviceInput] && videoDeviceInput) {
        [_captureSession addInput:videoDeviceInput];
//        self.activityDeviceInput = videoDeviceInput;
    }
    [_captureSession commitConfiguration];
    
    AVCaptureConnection *_videoConnection = nil;
    for (AVCaptureOutput *output in _captureSession.outputs) {
        if ([output isKindOfClass:[AVCaptureVideoDataOutput class]]) {
            _videoConnection = [output connectionWithMediaType:AVMediaTypeVideo];
        }
    }
    
    _videoConnection.videoMirrored = (self.iDevice.position == AVCaptureDevicePositionFront);
}

/**
 相机相关设置
 
 AVCaptureWhiteBalanceMode      平衡光
 AVCaptureFlashMode             闪光灯
 AVCaptureFocusMode             对焦
 AVCaptureExposureMode          曝光
 */
- (void)setupCamera {
    self.captureSession = [[AVCaptureSession alloc] init];
    
    [self.captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    // add input and output
    
    [self.captureSession beginConfiguration];
    
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    
    self.iDevice = videoDevice;
    
    if ([self.captureSession canAddInput:videoDeviceInput] && videoDeviceInput) {
        [self.captureSession addInput:videoDeviceInput];
    }
    
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                       [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [videoDataOutput setVideoSettings:rgbOutputSettings];
    [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    [videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];

    if ([self.captureSession canAddOutput:videoDataOutput]){
        [self.captureSession addOutput:videoDataOutput];
    }
    
    // Audio data output
    AVCaptureAudioDataOutput *audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
    [audioDataOutput setSampleBufferDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    if ([self.captureSession canAddOutput:audioDataOutput]) {
        [self.captureSession addOutput:audioDataOutput];
    }
    
    [self.captureSession commitConfiguration];
    
    // config session
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        // 判断是否支持 1280x720 分辨率
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.previewLayer setFrame:[self.view.layer bounds]];
        [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    });
    
    [self.captureSession startRunning];
    
    UITapGestureRecognizer *focusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusTap:)];
    [self.view addGestureRecognizer:focusTap];
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureEvent:)];
    [self.view addGestureRecognizer:panGes];
}

- (void)setExposure:(CGFloat)exposure {
    
    if ([self.iDevice lockForConfiguration:nil]) {
        [self.iDevice setExposureTargetBias:exposure completionHandler:nil];
        [self.iDevice unlockForConfiguration];
    }
}

- (void)handlePanGestureEvent:(UIPanGestureRecognizer *)panGes {
    CGPoint translation = [panGes translationInView:self.view];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    // claculate translation
    CGFloat tyScale = translation.y/screenSize.height;
    
    CGFloat maxY = CGRectGetMidY(self.focusIV.frame) - 20 + SUN_LINE_HALF_HEIGHT;
    CGFloat minY = CGRectGetMidY(self.focusIV.frame) - 20 - SUN_LINE_HALF_HEIGHT;
    
    CGFloat ay = self.sunIV.center.y + tyScale;
    if (ay > maxY) {
        ay = maxY;
    } else if (ay < minY) {
        ay = minY;
    }
    
    self.sunIV.center = CGPointMake(self.sunIV.center.x, ay);
    
    CGFloat ex = ((self.focusIV.center.y - self.sunIV.center.y) * 8) / SUN_LINE_HALF_HEIGHT;
    ex = MAX(ex, -8);
    ex = MIN(ex, 8);
    [self setExposure:ex];
}

- (void)focusTap:(UITapGestureRecognizer *)tapGes {
    // focus camera
    CGSize vSize = self.view.bounds.size;
    CGPoint point = [tapGes locationInView:self.view];
    // 转换坐标
    CGPoint focusCenter = CGPointMake( point.y /vSize.height ,1-point.x/vSize.width );
    
    [self.iDevice lockForConfiguration:nil];
    //对焦模式和对焦点
    if ([self.iDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [self.iDevice setFocusPointOfInterest:focusCenter];
        [self.iDevice setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    //曝光模式和曝光点
    if ([self.iDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
        [self.iDevice setExposurePointOfInterest:focusCenter];
        [self.iDevice setExposureMode:AVCaptureExposureModeAutoExpose];
    }
    
    [self.iDevice setExposureTargetBias:0 completionHandler:nil];
//    [self.iDevice setFocusPointOfInterest:focusCenter];
    [self.iDevice unlockForConfiguration];
    
    self.focusIV.center = point;
    [self resetFocusFrame];
}

- (void)resetFocusFrame {
    
    self.focusIV.hidden = NO;
    self.sunIV.hidden = NO;
    
    self.sunIV.frame = CGRectMake(CGRectGetMaxX(self.focusIV.frame), CGRectGetMidY(self.focusIV.frame) - 10, CGRectGetWidth(self.sunIV.frame), CGRectGetHeight(self.sunIV.frame));
    self.sunLineView.center = self.sunIV.center;
}

// handler image
- (UIImage *)uiImageFromPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    CIImage *ciimage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer: @(YES)}];
    
    CGRect imageRect = CGRectMake(0, 0, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer));
    CGImageRef videoImage = [context createCGImage:ciimage fromRect:imageRect];
    
    UIImage *image = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    
    return image;
}

- (void)handleAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    // audio
}

- (void)handleVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    // get capture data
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    OSType osType = CVPixelBufferGetPixelFormatType(pixelBuffer);
    
    switch (osType) {
        case kCVPixelFormatType_32RGBA:
            break;
        case kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange:
            break;
        case kCVPixelFormatType_420YpCbCr8BiPlanarFullRange:
            break;
            
        default:
            break;
    }
    
//    性能消耗较高，不适合频繁提取
//    [self uiImageFromPixelBuffer:pixelBuffer];
    
    
//    CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, pixelBuffer, NULL, GL_TEXTURE_2D, GL_RGB_422_APPLE, width, height, GL_RGB_422_APPLE, GL_UNSIGNED_SHORT_8_8_APPLE, 1, &outTexture);
    
    CVOpenGLESTextureCacheRef textureCache;
    CVEAGLContext context = [EAGLContext currentContext];
    CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, context, NULL, &textureCache);
    CVOpenGLESTextureRef pixelBufferTexture;

    
    CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                 textureCache,
                                                 pixelBuffer,
                                                 NULL,
                                                 GL_TEXTURE_2D,
                                                 GL_RGBA,
                                                 (GLsizei)CVPixelBufferGetWidth(pixelBuffer),
                                                 (GLsizei)CVPixelBufferGetHeight(pixelBuffer),
                                                 GL_BGRA,
                                                 GL_UNSIGNED_BYTE,
                                                 0,
                                                 &pixelBufferTexture);
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate/AVCaptureAudioDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if ([output isKindOfClass:AVCaptureVideoDataOutput.class]) {
        [self handleVideoSampleBuffer:sampleBuffer fromConnection:connection];
    } else if ([output isKindOfClass:AVCaptureAudioDataOutput.class]) {
        [self handleAudioSampleBuffer:sampleBuffer fromConnection:connection];
    }
    
}

- (void)captureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    // camera drop frame
    
    if ([self.iDevice isFocusPointOfInterestSupported]) {
        // 是否支持聚焦
    }
}

#pragma mark - Layout
- (UIImageView *)sunIV {
    if (!_sunIV) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sun"]];
        iv.frame = CGRectMake(CGRectGetMaxX(self.focusIV.frame), CGRectGetMidY(self.focusIV.frame) - 20, 40, 40);
        
        _sunIV = iv;
        [self.view addSubview:_sunIV];
    }
    return _sunIV;
}

- (UIImageView *)focusIV {
    if (!_focusIV) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"objective"]];
        iv.frame = CGRectMake(30, 100, 50, 50);
        
        _focusIV = iv;
        [self.view addSubview:_focusIV];
    }
    return _focusIV;
}

- (UIView *)sunLineView {
    if (!_sunLineView) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.0, SUN_LINE_HALF_HEIGHT * 2)];
        lineView.backgroundColor = [UIColor colorWithRed:243/255.0 green:202/255.0 blue:126/255.0 alpha:1];
        lineView.center = self.sunIV.center;
        
        _sunLineView = lineView;
        [self.view addSubview:_sunLineView];
    }
    return _sunLineView;
}

@end
