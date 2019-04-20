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

@interface NetworkService : NSObject <NSURLSessionDelegate, NSURLSessionDownloadDelegate, NetworkServiceInputProtocol>

@property (nonatomic, weak) id<NetworkServiceOutputProtocol> output; /**< Делегат внешних событий */

@end

NS_ASSUME_NONNULL_END
