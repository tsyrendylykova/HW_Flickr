//
//  ViewController.m
//  HWFlickr
//
//  Created by Цырендылыкова Эржена on 15/04/2019.
//  Copyright © 2019 Erzhena Tsyrendylykova. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "NetworkService.h"
#import "NetworkServiceProtocol.h"
#import "HWEditPhotoViewController.h"

@import UserNotifications;

typedef NS_ENUM(NSInteger, LCTTriggerType) {
    LCTTriggerTypeInterval = 0,
    LCTTriggerTypeDate = 1,
    LCTTriggerTypeLocation = 2
};

@interface ViewController () <NetworkServiceOutputProtocol>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic, strong) NetworkService *networkService;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self prepareUI];
    
    self.networkService = [NetworkService new];
    self.networkService.viewController = self;
    self.networkService.output = self;
    self.photosArray = [NSMutableArray new];
    
    if (!self.searchString && ![self.searchString isEqual: @"Sunset"]) {
        self.searchString = @"Sunset";
    }
    [self.networkService findFlickrPhotoWithSearchString:self.searchString];
    [self addCustomCategories];
}

-(void)prepareUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Flickr search";
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 88, self.view.frame.size.width, 50)];
    self.searchBar.delegate = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame)/2 - 2.5, CGRectGetWidth(self.view.frame)/2 - 2.5);
    layout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 138, self.view.frame.size.width, self.view.frame.size.height - 138) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithRed:240/255.f green:255/255.f blue:240/255.f alpha:1];
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.collectionView];
}

#pragma mark - Search Bar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%@", searchBar.text);
    [self.photosArray removeAllObjects];
    [self.networkService findFlickrPhotoWithSearchString: searchBar.text];
}

#pragma mark - UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [CollectionViewCell new];
    }
    if (self.photosArray.count) {
        cell.coverImageView.image = self.photosArray[indexPath.row];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *image = self.photosArray[indexPath.row];
    HWEditPhotoViewController *editPhotoViewController = [[HWEditPhotoViewController alloc] initWithImage:image];
    [self.navigationController pushViewController:editPhotoViewController animated:YES];
}

- (void)loadingIsDoneWithDataRecieved:(NSData *)dataRecieved {
    UIImage *image = [UIImage imageWithData:dataRecieved];
    if (image) {
        [self.photosArray addObject:image];
        [self.collectionView reloadData];
    }
}

-(void)scheduleLocalNotification {
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"Flickr";
    content.body = @"Вы давно не заходили к нам! Посмотрите на собачек! \U0001F47B \U0001F431";
    content.sound = [UNNotificationSound defaultSound];
    
    content.badge = @([self giveNewBadgeNumber] + 1);
    
    UNNotificationAttachment *attachment = [self imageAttachment];
    if (attachment) {
        content.attachments = @[attachment];
    }
    
    content.categoryIdentifier = @"LCTReminderCategory";
    
    NSDictionary *dict = @{@"color": @"red"};
    content.userInfo = dict;
    
    
    NSString *identifier = @"NotificationId";
    UNNotificationTrigger *trigger = [self triggerWithType:LCTTriggerTypeInterval];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Something goes wrong");
        }
    }];
}

-(UNTimeIntervalNotificationTrigger*) intervalTrigger {
    return [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:30 repeats:NO];
}

-(UNLocationNotificationTrigger*) locationTrigger {
    //    CLRegion *region
    //    return [UNLocationNotificationTrigger triggerWithRegion:<#(nonnull CLRegion *)#> repeats:NO];
    return nil;
}

-(UNCalendarNotificationTrigger*) dateTrigger {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:360];
    NSDateComponents *triggerDate = [[NSCalendar currentCalendar] components:NSCalendarUnitYear + NSCalendarUnitMonth + NSCalendarUnitDay + NSCalendarUnitHour + NSCalendarUnitMinute + NSCalendarUnitSecond fromDate:date];
    return [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];
}

-(NSInteger)giveNewBadgeNumber {
    return [UIApplication sharedApplication].applicationIconBadgeNumber;
}

-(UNNotificationTrigger *)triggerWithType: (LCTTriggerType)triggerType {
    switch(triggerType) {
        case LCTTriggerTypeInterval:
            return [self intervalTrigger];
        case LCTTriggerTypeLocation:
            return [self locationTrigger];
        case LCTTriggerTypeDate:
            return [self dateTrigger];
        default:
            break;
    }
    return nil;
}

-(UNNotificationAttachment *)imageAttachment {
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"dog" withExtension:@"jpg"];
    NSError *error;
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"pushImages" URL:fileURL options:nil error:&error];
    
    return attachment;
}

-(void)addCustomCategories {
    UNNotificationAction *checkAction = [UNNotificationAction actionWithIdentifier:@"checkID" title:@"i am title" options:UNNotificationActionOptionNone];
    UNNotificationAction *deleteAction = [UNNotificationAction actionWithIdentifier:@"deleteID" title:@"delete" options:UNNotificationActionOptionDestructive];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"LCTReminderCategory" actions:@[checkAction, deleteAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    NSSet *categories = [NSSet setWithObject:category];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setNotificationCategories:categories];
}

@end
