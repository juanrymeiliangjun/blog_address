//
//  ViewController.m
//  GPUImageDemo
//
//  Created by meiliangjun1_vendor on 2021/4/1.
//  Copyright © 2021 meiliangjun1_vendor. All rights reserved.
//

#import "ViewController.h"
#import "CameraPreviewController.h"
#import "CameraOpenGLViewController.h"

#import <GPUImage/GPUImageFramework.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *orginImage;
@property (weak, nonatomic) IBOutlet UIImageView *filterImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *personImage = [UIImage imageNamed:@"person"];
    
    self.orginImage.image = personImage;
    
    GPUImageSketchFilter *skFilter = [[GPUImageSketchFilter alloc] init];
    [skFilter forceProcessingAtSize:personImage.size];
    [skFilter useNextFrameForImageCapture];
    
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:personImage];
    [picture addTarget:skFilter];
    [picture processImage];
    
    UIImage *newImage = [skFilter imageFromCurrentFramebuffer];
    self.filterImageView.image = newImage;
    
}

- (IBAction)pushCameraVC:(id)sender {
    
    [self.navigationController pushViewController:[[CameraPreviewController alloc] init] animated:YES];
}

- (IBAction)pushOpenGLVC:(id)sender {
    [self.navigationController pushViewController:[[CameraOpenGLViewController alloc] init] animated:YES];
}

@end
