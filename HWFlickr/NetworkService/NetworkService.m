//
//  NetworkService.m
//  HWFlickr
//
//  Created by Цырендылыкова Эржена on 17/04/2019.
//  Copyright © 2019 Erzhena Tsyrendylykova. All rights reserved.
//

#import "NetworkService.h"
#import "NetworkHelper.h"
#import "ImagesModel.h"

@implementation NetworkService

-(void)findFlickrPhotoWithSearchString: (NSString *)searchString {
    NSLog(@"find photo in network service");
    
    NSString *urlString = [NetworkHelper URLForSearchString: searchString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:15];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        NSMutableArray<ImagesModel *> *array = [NSMutableArray new];
        for (id photo in temp[@"photos"][@"photo"]) {
            
            NSString *urlString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", photo[@"farm"], photo[@"server"], photo[@"id"], photo[@"secret"]];
            [self downloadTaskWithURL:urlString];

            ImagesModel *model = [ImagesModel new];
            model.title = photo[@"title"];
            model.photoURL = urlString;
            [array addObject:model];
            
        }
        self.photosArray = array;
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.output loadingIsDoneWithDataRecieved:data];
        });
    }];

    [sessionDataTask resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.output loadingIsDoneWithDataRecieved:data];
    });
    [session finishTasksAndInvalidate];
}

-(void)downloadTaskWithURL: (NSString *)stringURL {
    NSURLSession *session;
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:stringURL]];

    [downloadTask resume];
}

@end
