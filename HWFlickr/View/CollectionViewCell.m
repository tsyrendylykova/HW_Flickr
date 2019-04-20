//
//  CollectionViewCell.m
//  HWFlickr
//
//  Created by Цырендылыкова Эржена on 17/04/2019.
//  Copyright © 2019 Erzhena Tsyrendylykova. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(frame) - 10, CGRectGetHeight(frame) - 10)];
        _coverImageView = imageView;
        _coverImageView.layer.cornerRadius = 10;
        _coverImageView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:_coverImageView];
    }
    return self;
}

@end
