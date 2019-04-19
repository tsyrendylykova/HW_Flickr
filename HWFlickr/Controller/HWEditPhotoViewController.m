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
@property (nonatomic, strong) UILabel *labelSepiaTone;
@property (nonatomic, strong) UISlider *sliderSepiaTone;
@property (nonatomic, strong) UILabel *labelColorCubeTone;
@property (nonatomic, strong) UISlider *sliderColorCubeTone;

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
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 99, self.view.frame.size.width - 20, self.view.frame.size.height * 0.65)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.image;
    
    self.labelSepiaTone = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageView.frame.origin.y + self.imageView.frame.size.height + 10, self.view.frame.size.width, 30)];
    [self.labelSepiaTone setText:@"Change SEPIA filter"];
    self.labelSepiaTone.textAlignment = NSTextAlignmentCenter;
    self.labelSepiaTone.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.labelSepiaTone.layer.cornerRadius = 10;
    self.labelSepiaTone.layer.masksToBounds = YES;
    
    self.sliderSepiaTone = [[UISlider alloc] initWithFrame:CGRectMake(10, self.labelSepiaTone.frame.origin.y + self.labelSepiaTone.frame.size.height + 5, self.view.frame.size.width - 20, 30)];
    self.sliderSepiaTone.value = 0.5;
    [self.sliderSepiaTone addTarget:self action:@selector(changeSepiaTone) forControlEvents:UIControlEventValueChanged];
    
    self.labelColorCubeTone = [[UILabel alloc] initWithFrame:CGRectMake(0, self.sliderSepiaTone.frame.origin.y + self.sliderSepiaTone.frame.size.height + 15, self.view.frame.size.width, 30)];
    [self.labelColorCubeTone setText:@"Change COLOR CUBE filter"];
    self.labelColorCubeTone.textAlignment = NSTextAlignmentCenter;
    self.labelColorCubeTone.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.labelColorCubeTone.layer.cornerRadius = 10;
    self.labelColorCubeTone.layer.masksToBounds = YES;
    
    
    self.sliderColorCubeTone = [[UISlider alloc] initWithFrame:CGRectMake(10, self.labelColorCubeTone.frame.origin.y + self.labelColorCubeTone.frame.size.height + 5, self.view.frame.size.width - 20, 30)];
    self.sliderColorCubeTone.value = 0.5;
    [self.sliderColorCubeTone addTarget:self action:@selector(changeColorCubeTone) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.labelSepiaTone];
    [self.view addSubview:self.sliderSepiaTone];
    [self.view addSubview:self.labelColorCubeTone];
    [self.view addSubview:self.sliderColorCubeTone];
}

-(void)goBackToVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)changeSepiaTone {
    NSNumber *intensity = [NSNumber numberWithFloat:(0.01 + self.sliderSepiaTone.value) * 2];
    
    CIImage *beginImage = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filterSepia = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        kCIInputIntensityKey, intensity, nil];
    CIImage *outputImage = [filterSepia outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    self.imageView.image = newImage;
    
    CGImageRelease(cgimg);
}

-(void)changeColorCubeTone {
    NSNumber *intensity = [NSNumber numberWithFloat:self.sliderColorCubeTone.value / 2];
    
    CIImage *beginImage = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *blackAndWhite = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.1], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil].outputImage;
    CIImage *output = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, blackAndWhite, @"inputEV", intensity, nil].outputImage;
    
    CGImageRef cgimg = [context createCGImage:output fromRect:[output extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    self.imageView.image = newImage;
    
    CGImageRelease(cgimg);
}


@end
