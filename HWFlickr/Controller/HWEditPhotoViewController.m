//
//  HWEditPhotoViewController.m
//  HWFlickr
//
//  Created by Цырендылыкова Эржена on 19/04/2019.
//  Copyright © 2019 Erzhena Tsyrendylykova. All rights reserved.
//

#import "HWEditPhotoViewController.h"

@interface HWEditPhotoViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UILabel *labelSepiaTone;
@property (nonatomic, strong) UISlider *sliderSepiaTone;
@property (nonatomic, strong) UILabel *labelColorControlsTone;
@property (nonatomic, strong) UISlider *sliderColorControlsTone;
@property (nonatomic, strong) UILabel *labelExposureAdjustTone;
@property (nonatomic, strong) UISlider *sliderExposureAdjustTone;

@end

@implementation HWEditPhotoViewController

-(instancetype)initWithImage: (UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

-(void)prepareUI {
    self.navigationItem.title = @"Edit photo";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.f green:255/255.f blue:240/255.f alpha:1];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 99, self.view.frame.size.width - 20, self.view.frame.size.height * 0.6)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.image;
    
    self.labelSepiaTone = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageView.frame.origin.y + self.imageView.frame.size.height + 5, self.view.frame.size.width, 30)];
    [self.labelSepiaTone setText:@"Change SEPIA filter"];
    self.labelSepiaTone.textAlignment = NSTextAlignmentCenter;
    self.labelSepiaTone.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.labelSepiaTone.layer.cornerRadius = 10;
    self.labelSepiaTone.layer.masksToBounds = YES;
    
    self.sliderSepiaTone = [[UISlider alloc] initWithFrame:CGRectMake(10, self.labelSepiaTone.frame.origin.y + self.labelSepiaTone.frame.size.height + 5, self.view.frame.size.width - 20, 30)];
    self.sliderSepiaTone.value = 0.5;
    [self.sliderSepiaTone addTarget:self action:@selector(changeSepiaTone) forControlEvents:UIControlEventValueChanged];
    
    self.labelColorControlsTone = [[UILabel alloc] initWithFrame:CGRectMake(0, self.sliderSepiaTone.frame.origin.y + self.sliderSepiaTone.frame.size.height + 10, self.view.frame.size.width, 30)];
    [self.labelColorControlsTone setText:@"Change COLOR CUBE filter"];
    self.labelColorControlsTone.textAlignment = NSTextAlignmentCenter;
    self.labelColorControlsTone.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.labelColorControlsTone.layer.cornerRadius = 10;
    self.labelColorControlsTone.layer.masksToBounds = YES;
    
    self.sliderColorControlsTone = [[UISlider alloc] initWithFrame:CGRectMake(10, self.labelColorControlsTone.frame.origin.y + self.labelColorControlsTone.frame.size.height + 5, self.view.frame.size.width - 20, 30)];
    self.sliderColorControlsTone.value = 0.5;
    [self.sliderColorControlsTone addTarget:self action:@selector(changeColorCubeTone) forControlEvents:UIControlEventValueChanged];
    
    self.labelExposureAdjustTone = [[UILabel alloc] initWithFrame:CGRectMake(0, self.sliderColorControlsTone.frame.origin.y + self.sliderColorControlsTone.frame.size.height + 10, self.view.frame.size.width, 30)];
    [self.labelExposureAdjustTone setText:@"Change EXPOSURE AdJUST filter"];
    self.labelExposureAdjustTone.textAlignment = NSTextAlignmentCenter;
    self.labelExposureAdjustTone.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.labelExposureAdjustTone.layer.cornerRadius = 10;
    self.labelExposureAdjustTone.layer.masksToBounds = YES;
    
    self.sliderExposureAdjustTone = [[UISlider alloc] initWithFrame:CGRectMake(10, self.labelExposureAdjustTone.frame.origin.y + self.labelExposureAdjustTone.frame.size.height + 5, self.view.frame.size.width - 20, 30)];
    self.sliderExposureAdjustTone.value = 0.5;
    [self.sliderExposureAdjustTone addTarget:self action:@selector(changeExposureAdjustTone) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.labelSepiaTone];
    [self.view addSubview:self.sliderSepiaTone];
    [self.view addSubview:self.labelColorControlsTone];
    [self.view addSubview:self.sliderColorControlsTone];
    [self.view addSubview:self.labelExposureAdjustTone];
    [self.view addSubview:self.sliderExposureAdjustTone];
}

-(void)goBackToVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)changeSepiaTone {
    NSNumber *intensity = [NSNumber numberWithFloat:self.sliderSepiaTone.value * 2 - 1];
    
    CIImage *beginImage = [CIImage imageWithCGImage:self.image.CGImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filterSepia = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, beginImage, kCIInputIntensityKey, intensity, nil];
    CIImage *outputImage = [filterSepia outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    self.imageView.image = newImage;
    
    CGImageRelease(cgimg);
}

-(void)changeColorCubeTone {
    NSNumber *intensity = [NSNumber numberWithFloat:self.sliderColorControlsTone.value * 2 - 1];

    CIImage *beginImage = [CIImage imageWithCGImage:self.image.CGImage];
    CIContext *context = [CIContext contextWithOptions:nil];

    CIImage *output = [[CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", intensity, @"inputContrast", [NSNumber numberWithFloat:1.1], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil] outputImage];

    CGImageRef cgimg = [context createCGImage:output fromRect:[output extent]];

    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    self.imageView.image = newImage;

    CGImageRelease(cgimg);
}

-(void)changeExposureAdjustTone {
    NSNumber *intensity = [NSNumber numberWithFloat:self.sliderExposureAdjustTone.value];
    
    CIImage *beginImage = [CIImage imageWithCGImage:self.image.CGImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues: kCIInputImageKey, beginImage, kCIInputEVKey, intensity, nil];
    CIImage *outputImage = [filter outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    self.imageView.image = newImage;
    
    CGImageRelease(cgimg);
}


@end
