//
//  NetworkServiceProtocol.h
//  HWFlickr
//
//  Created by Цырендылыкова Эржена on 17/04/2019.
//  Copyright © 2019 Erzhena Tsyrendylykova. All rights reserved.
//

@protocol NetworkServiceOutputProtocol <NSObject>
@optional

-(void)loadingIsDoneWithDataRecieved:(NSData *)dataRecieved;

@end

@protocol NetworkServiceInputProtocol <NSObject>
@optional

-(void)findFlickrPhotoWithSearchString: (NSString *)searchString;

@end
