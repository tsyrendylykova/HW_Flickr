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
    UNMutableNotificationContent *contentDog = [UNMutableNotificationContent new];
    contentDog.title = @"\U0001F436 Flickr \U0001F436";
    contentDog.body = @"Вы давно не заходили к нам! Посмотрите на собачек! \U0001F436";
    contentDog.sound = [UNNotificationSound defaultSound];
    contentDog.badge = @([self giveNewBadgeNumber] + 1);
    
    UNMutableNotificationContent *contentCat = [UNMutableNotificationContent new];
    contentCat.title = @"\U0001F431 Flickr \U0001F431";
    contentCat.body = @"Вы давно не заходили к нам! Посмотрите на котят! \U0001F431";
    contentCat.sound = [UNNotificationSound defaultSound];
    contentCat.badge = @([self giveNewBadgeNumber] + 1);
    
    UNNotificationAttachment *attachmentDog = [self imageAttachment];
    if (attachmentDog) {
        contentDog.attachments = @[attachmentDog];
    }
    
    UNNotificationAttachment *attachmentCat = [self imageAttachment];
    if (attachmentCat) {
        contentCat.attachments = @[attachmentCat];
    }
    
    contentDog.categoryIdentifier = @"LCTReminderCategory";
    contentCat.categoryIdentifier = @"LCTReminderCategorySecond";
    
    NSDictionary *dict = @{@"color": @"red"};
    contentDog.userInfo = dict;
    
    
    NSString *identifier = @"NotificationId";
    NSString *identifierSecond = @"NotificationIdSecond";
    UNNotificationTrigger *trigger = [self triggerWithType:LCTTriggerTypeInterval];
    
    UNNotificationTrigger *triggerSecond = [self triggerWithType:LCTTriggerTypeLocation];
    
    UNNotificationRequest *requestDog = [UNNotificationRequest requestWithIdentifier:identifier content:contentDog trigger:trigger];
    UNNotificationRequest *requestCat = [UNNotificationRequest requestWithIdentifier:identifierSecond content:contentCat trigger:triggerSecond];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:requestDog withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Something goes wrong");
        }
    }];
    [center addNotificationRequest:requestCat withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Something goes wrong");
        }
    }];
}

-(UNTimeIntervalNotificationTrigger*) intervalTrigger {
    return [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
}

-(UNTimeIntervalNotificationTrigger*) intervalTriggerSecond {
    return [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
}

-(UNLocationNotificationTrigger*) locationTrigger {
    //    CLRegion *region
    //    return [UNLocationNotificationTrigger triggerWithRegion:<#(nonnull CLRegion *)#> repeats:NO];
    return nil;
}

-(UNCalendarNotificationTrigger*) dateTrigger {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:3600];
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
            return [self intervalTriggerSecond];
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
    
    UNNotificationCategory *categorySecond = [UNNotificationCategory categoryWithIdentifier:@"LCTReminderCategorySecond" actions:@[checkAction, deleteAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    [categories setByAddingObject:categorySecond];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setNotificationCategories:categories];
}

@end
