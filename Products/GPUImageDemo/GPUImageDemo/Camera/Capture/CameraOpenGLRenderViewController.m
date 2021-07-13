//
//  CameraOpenGLRenderViewController.m
//  GPUImageDemo
//
//  Created by meiliangjun1_vendor on 2021/4/22.
//  Copyright © 2021 meiliangjun1_vendor. All rights reserved.
//

#import "CameraOpenGLRenderViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "RosyWriterCapturePipeline.h"
#import "OpenGLPixelBufferView.h"

@interface CameraOpenGLRenderViewController () {
    OpenGLPixelBufferView *_previewView;
    RosyWriterCapturePipeline *_capturePipeline;
}

@end

@implementation CameraOpenGLRenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
