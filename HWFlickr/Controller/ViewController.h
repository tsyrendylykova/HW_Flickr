//
//  ViewController.h
//  HWFlickr
//
//  Created by Цырендылыкова Эржена on 15/04/2019.
//  Copyright © 2019 Erzhena Tsyrendylykova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) NSString *searchString;

-(instancetype)initWithSearchString: (NSString *)searchString;
-(void)scheduleLocalNotification;

@end

