//
//  ImagesModel.h
//  HWFlickr
//
//  Created by Цырендылыкова Эржена on 18/04/2019.
//  Copyright © 2019 Erzhena Tsyrendylykova. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImagesModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *photoURL;
@property (nonatomic, strong) UIImage *image;

@end

NS_ASSUME_NONNULL_END
