//
//  CameraOpenGLViewController.m
//  GPUImageDemo
//
//  Created by meiliangjun1_vendor on 2021/4/13.
//  Copyright © 2021 meiliangjun1_vendor. All rights reserved.
//

#import "CameraOpenGLViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <GLKit/GLKit.h>

@interface CameraOpenGLViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDevice *iDevice;
@property (nonatomic, strong) GLKView *glkView;
@property (nonatomic, strong) CIContext *cicontext;

@property (nonatomic, weak) UIImageView *sunIV;
@property (nonatomic, weak) UIImageView *focusIV;

@end

@implementation CameraOpenGLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupGLKView];
    [self setupCamera];
    
    [self focusIV];
    [self sunIV];
    
    UITapGestureRecognizer *focusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusTap:)];
    [self.view addGestureRecognizer:focusTap];
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureEvent:)];
    [self.view addGestureRecognizer:panGes];
}

- (void)setupGLKView {
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.glkView = [[GLKView alloc]initWithFrame:self.view.bounds context:context];
    [EAGLContext setCurrentContext:context];
    [self.view addSubview:self.glkView];
    self.glkView.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.glkView.frame = [UIApplication sharedApplication].keyWindow.bounds;

    self.cicontext = [CIContext contextWithEAGLContext:context];
}

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
    
    [self.captureSession commitConfiguration];
    
    // config session
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        // 判断是否支持 1280x720 分辨率
        [self.captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
    }
    
    [self.captureSession startRunning];
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
    
    self.sunIV.frame = CGRectMake(CGRectGetMaxX(self.focusIV.frame) + 10, CGRectGetMidY(self.focusIV.frame) - 10, 20, 20);
}

- (void)setExposure:(CGFloat)exposure {
    
    if ([self.iDevice lockForConfiguration:nil]) {
        [self.iDevice setExposureTargetBias:exposure completionHandler:nil];
        [self.iDevice unlockForConfiguration];
    }
}

- (void)handlePanGestureEvent:(UIPanGestureRecognizer *)panGes {
    CGPoint translation = [panGes translationInView:self.view];
    
    CGFloat maxY = CGRectGetMidY(self.focusIV.frame) - 10 + 40;
    CGFloat minY = CGRectGetMidY(self.focusIV.frame) - 10 - 40;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat screenScale = -8.0/screenSize.height;
    CGFloat ty = translation.y * 80 / screenSize.width;
    
    CGFloat ay = self.sunIV.center.y + ty;
    if (ay > maxY) {
        ay = maxY;
    } else if (ay < minY) {
        ay = minY;
    }
    
    self.sunIV.center = CGPointMake(self.sunIV.center.x, ay);
    
    CGFloat ex = (translation.y * screenScale) + self.iDevice.exposureTargetBias;
    ex = MAX(ex, -8);
    ex = MIN(ex, 8);
    NSLog(@"exposure: %0.2f, screen scale: %0.2f, ay: %0.2f, ty: %.2f, translate:(%.2f,%.2f)", ex, screenScale, ay, ty, translation.x, translation.y);
    [self setExposure:ex];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
//    if (self.glkView.context != [EAGLContext currentContext]) {
//        [EAGLContext setCurrentContext:self.glkView.context];
//    }
//
//    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer: @(YES)}];
//
//    CVImageBufferRef imageRef = CMSampleBufferGetImageBuffer(sampleBuffer);
//    CIImage *image = [CIImage imageWithCVImageBuffer:imageRef];
//    [self.glkView bindDrawable];
//    [self.cicontext drawImage:image inRect:image.extent fromRect:image.extent];
//    [self.glkView display];
    
    if (self.glkView.context != [EAGLContext currentContext]) {
        [EAGLContext setCurrentContext:self.glkView.context];
    }
    CVImageBufferRef imageRef = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *image = [CIImage imageWithCVImageBuffer:imageRef];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.glkView bindDrawable];
        [self.cicontext drawImage:image inRect:image.extent fromRect:image.extent];
        [self.glkView display];
    });
}

#pragma mark - Layout
- (UIImageView *)sunIV {
    if (!_sunIV) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sun"]];
        iv.frame = CGRectMake(CGRectGetMaxX(self.focusIV.frame) + 10, CGRectGetMidY(self.focusIV.frame) - 10, 20, 20);
        
        _sunIV = iv;
        [self.view addSubview:_sunIV];
    }
    return _sunIV;
}

- (UIImageView *)focusIV {
    if (!_focusIV) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"focus"]];
        iv.frame = CGRectMake(30, 100, 50, 50);
        
        _focusIV = iv;
        [self.view addSubview:_focusIV];
    }
    return _focusIV;
}

@end
