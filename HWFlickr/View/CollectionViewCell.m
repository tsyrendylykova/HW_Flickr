//
//  CollectionViewCell.m
//  HWFlickr
//
//  Created by Цырендылыкова Эржена on 17/04/2019.
//  Copyright © 2019 Erzhena Tsyrendylykova. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell()

@end

@implementation CollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetHeight(frame) - 20, 25)];
////        label.backgroundColor = [UIColor yellowColor];
//        _titleLabel = label;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(frame) - 10, CGRectGetHeight(frame) - 10)];
        _coverImageView = imageView;
        _coverImageView.layer.cornerRadius = 10;
        _coverImageView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:_coverImageView];
//        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

@end
