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
#import "ImagesModel.h"
#import "HWEditPhotoViewController.h"

@interface ViewController () <NetworkServiceOutputProtocol>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NetworkService *networkService;
@property (nonatomic, strong) NSMutableArray<ImagesModel *> *photosModelArray;
@property (nonatomic, strong) NSMutableArray *photosArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self prepareUI];
    
    self.networkService = [NetworkService new];
    self.networkService.viewController = self;
    self.networkService.output = self;
    self.photosArray = [NSMutableArray new];
    
    [self.networkService findFlickrPhotoWithSearchString: @"Sunset"];

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
        cell.titleLabel.text = self.photosModelArray[indexPath.row].title;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImage *image = self.photosArray[indexPath.row];
    HWEditPhotoViewController *editPhotoViewController = [HWEditPhotoViewController new];
    
    [self presentViewController:editPhotoViewController animated:YES completion:nil];
    editPhotoViewController.imageView.image = image;
}

- (void)loadingIsDoneWithDataRecieved:(NSData *)dataRecieved {
    UIImage *image = [UIImage imageWithData:dataRecieved];
    if (image) {
        [self.photosArray addObject:image];
        [self.collectionView reloadData];
    }
}

@end
