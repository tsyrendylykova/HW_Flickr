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
    LCTTriggerTypeDate = 1
};

@interface ViewController () <NetworkServiceOutputProtocol>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic, strong) NetworkService *networkService;

@end

@implementation ViewController

- (instancetype)initWithSearchString: (NSString *)searchString {
    self = [super init];
    if (self) {
        _searchString = searchString;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self prepareUI];
    
    self.networkService = [NetworkService new];
    self.networkService.output = self;
    [self.networkService findFlickrPhotoWithSearchString:self.searchString];
    self.photosArray = [NSMutableArray new];
    [self addCustomCategoriesWithIdentifier:@"ReminderCategoryLastSearch" andIdentifier:@"ReminderCategoryCatSearch"];
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
    self.searchString = searchBar.text;
    [self.networkService findFlickrPhotoWithSearchString: self.searchString];
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

#pragma mark - NSURL

- (void)loadingIsDoneWithDataRecieved:(NSData *)dataRecieved {
    UIImage *image = [UIImage imageWithData:dataRecieved];
    if (image) {
        [self.photosArray addObject:image];
        [self.collectionView reloadData];
    }
}

#pragma mark - Notifications

-(void)scheduleLocalNotification {
    UNMutableNotificationContent *contentDog = [UNMutableNotificationContent new];
    contentDog.title = @"\U0001F436 Flickr \U0001F436";
    contentDog.body = @"Вы давно не заходили к нам! Посмотрите на собачек!";
    contentDog.sound = [UNNotificationSound defaultSound];
    contentDog.badge = @([self giveNewBadgeNumber] + 1);
    
    UNMutableNotificationContent *contentCat = [UNMutableNotificationContent new];
    contentCat.title = @"\U0001F431 Flickr \U0001F431";
    contentCat.body = @"Вы давно не заходили к нам! Посмотрите на котят!";
    contentCat.sound = [UNNotificationSound defaultSound];
    contentCat.badge = @([self giveNewBadgeNumber] + 1);
    
    UNNotificationAttachment *attachmentDog = [self imageAttachmentWithName:@"dog"];
    if (attachmentDog) {
        contentDog.attachments = @[attachmentDog];
    }
    
    UNNotificationAttachment *attachmentCat = [self imageAttachmentWithName:@"cat"];
    if (attachmentCat) {
        contentCat.attachments = @[attachmentCat];
    }
    
    contentDog.categoryIdentifier = @"ReminderCategoryLastSearch";
    contentCat.categoryIdentifier = @"ReminderCategoryCatSearch";
    
    NSDictionary *dict = @{@"search": self.searchString};
    contentDog.userInfo = dict;
    
    NSDictionary *dictSecond = @{@"search": @"Cat"};
    contentCat.userInfo = dictSecond;
    
    
    NSString *identifierDog = @"NotificationDog";
    NSString *identifierCat = @"NotificationCat";
    UNNotificationTrigger *triggerDog = [self triggerWithType:LCTTriggerTypeInterval];
    
    UNNotificationTrigger *triggerCat = [self triggerWithType:LCTTriggerTypeDate];
    
    UNNotificationRequest *requestDog = [UNNotificationRequest requestWithIdentifier:identifierDog content:contentDog trigger:triggerDog];
    UNNotificationRequest *requestCat = [UNNotificationRequest requestWithIdentifier:identifierCat content:contentCat trigger:triggerCat];
    
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

-(UNCalendarNotificationTrigger*) dateTrigger {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:10];
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
        case LCTTriggerTypeDate:
            return [self dateTrigger];
        default:
            break;
    }
    return nil;
}

-(UNNotificationAttachment *)imageAttachmentWithName: (NSString *)name  {
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"jpg"];
    NSError *error;
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"pushImages" URL:fileURL options:nil error:&error];
    
    return attachment;
}

-(void)addCustomCategoriesWithIdentifier: (NSString *)identifier andIdentifier:(NSString *)secondIdentifier {
    UNNotificationAction *checkAction = [UNNotificationAction actionWithIdentifier:@"checkID" title:@"i am title" options:UNNotificationActionOptionNone];
    UNNotificationAction *deleteAction = [UNNotificationAction actionWithIdentifier:@"deleteID" title:@"delete" options:UNNotificationActionOptionDestructive];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:identifier actions:@[checkAction, deleteAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    NSSet *categories = [NSSet setWithObject:category];
    
    UNNotificationCategory *categorySecond = [UNNotificationCategory categoryWithIdentifier:secondIdentifier actions:@[checkAction, deleteAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    [categories setByAddingObject:categorySecond];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setNotificationCategories:categories];
}

@end
