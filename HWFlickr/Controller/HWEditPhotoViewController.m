//
//  HWEditPhotoViewController.m
//  HWFlickr
//
//  Created by Цырендылыкова Эржена on 19/04/2019.
//  Copyright © 2019 Erzhena Tsyrendylykova. All rights reserved.
//

#import "HWEditPhotoViewController.h"

@interface HWEditPhotoViewController ()

@end

@implementation HWEditPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

-(void)prepareUI {
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.f green:255/255.f blue:240/255.f alpha:1];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.height * 0.75)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3, self.view.frame.size.height - 50, self.view.frame.size.width / 3, 50)];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor whiteColor];
    [backButton addTarget:self action:@selector(goBackToVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:backButton];
}

-(void)goBackToVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
