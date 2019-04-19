//
//  NetworkHelper.m
//  HWFlickr
//
//  Created by Цырендылыкова Эржена on 17/04/2019.
//  Copyright © 2019 Erzhena Tsyrendylykova. All rights reserved.
//

#import "NetworkHelper.h"

@implementation NetworkHelper

+(NSString *)URLForSearchString: (NSString *)searchString {
    NSString *APIKey = @"e30aacca8384bc3211aadffd8f0dbeb1";
    return [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=24&format=json&nojsoncallback=1", APIKey, searchString];
}

@end
