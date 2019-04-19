//
//  CollectionViewCell.h
//  HWFlickr
//
//  Created by Цырендылыкова Эржена on 17/04/2019.
//  Copyright © 2019 Erzhena Tsyrendylykova. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readwrite) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel* titleLabel;

@end

NS_ASSUME_NONNULL_END
