//
//  NetworkService.h
//  HWFlickr
//
//  Created by Цырендылыкова Эржена on 17/04/2019.
//  Copyright © 2019 Erzhena Tsyrendylykova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkServiceProtocol.h"
#import "ViewController.h"

@class ViewController;

NS_ASSUME_NONNULL_BEGIN

@interface NetworkService : NSObject <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, weak) id<NetworkServiceOutputProtocol> output; /**< Делегат внешних событий */
@property (nonatomic, strong) ViewController *viewController;

-(void)findFlickrPhotoWithSearchString: (NSString *)searchString;


@end

NS_ASSUME_NONNULL_END
