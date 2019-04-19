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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetHeight(frame) - 20, 25)];
//        label.backgroundColor = [UIColor yellowColor];
        _titleLabel = label;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, CGRectGetWidth(frame) - 20, CGRectGetHeight(frame) - 40)];
        _coverImageView = imageView;
        
        [self.contentView addSubview:_coverImageView];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

@end
