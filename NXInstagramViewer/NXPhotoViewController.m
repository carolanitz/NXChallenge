#import "NXPhotoViewController.h"
#import "NXPhotoCell.h"
#import <NXOAuth2Client/NXOAuth2Request.h>
#import <NXOAuth2Client/NXOAuth2AccountStore.h>
#import <NXOAuth2Client/NXOAuth2Account.h>
#import <NXOAuth2Client/NXOAuth2AccessToken.h>
#import "NXPhotoObject.h"

@interface NXPhotoViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation NXPhotoViewController
{
    UICollectionView *_collectionView;
    NSMutableArray *_photos;
    UIImageView *_imageView;
    CGRect prevFrame;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _photos = [NSMutableArray new];
        _imageView = [UIImageView new];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut:)];
        [_imageView addGestureRecognizer:tapGestureRecognizer];
        [_imageView setUserInteractionEnabled:YES];
        [self setupCollectionView];
        [self fetchPhotos];
    }
    return self;
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[NXPhotoCell class] forCellWithReuseIdentifier:@"NXPhotoCell"];
    [self.view addSubview:_collectionView];
}

- (void)fetchPhotos
{
    //this code plus especially imports and data parsing belong in an own file
    NXOAuth2Account *account = [[NXOAuth2AccountStore sharedStore] accountsWithAccountType:@"thisisatest"][0];

    [NXOAuth2Request performMethod:@"GET"
                        onResource:[NSURL URLWithString:@"https://api.instagram.com/v1/users/3/media/recent"]
                   usingParameters:@{@"access_token":account.accessToken.accessToken}
                       withAccount:account
               sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) { // e.g., update a progress indicator
               }
               responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                   if (error != nil) {
                       [[[UIAlertView alloc] initWithTitle:@"Fail!" message:[NSString stringWithFormat:@"couldn't load data \n error:%@",error.localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
                       return;
                   }

                   NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
                   NSArray *array = jsonArray[@"data"];
                   for (id object in array) {
                       NXPhotoObject *photoObject = [[NXPhotoObject alloc] initWithJSONObject:object];
                       if(photoObject)
                           [_photos addObject:photoObject];
                   }
                   [_collectionView reloadData];
               }];
}
#pragma mark - collectionView datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photos.count;
}

- (NXPhotoCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NXPhotoCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"NXPhotoCell" forIndexPath:indexPath];
    [cell updateWithPhotoObject:[_photos objectAtIndex:indexPath.row]];
    return cell;
}

// all numbers in static const upfront ideal would be to dynamically calculate cellsizes

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return CGSizeMake(200, 200);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}
#pragma mark - collectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view addSubview:_imageView];
    [self.view bringSubviewToFront:_imageView];
     NXPhotoCell *photocell = (NXPhotoCell*)[collectionView cellForItemAtIndexPath:indexPath];
    _imageView.image = photocell.imageView.image;

    CGPoint origin = [self.view convertPoint:photocell.imageView.frame.origin fromView:photocell];
    _imageView.frame = CGRectMake(origin.x, origin.y, photocell.imageView.bounds.size.width, photocell.imageView.bounds.size.height);
    prevFrame = _imageView.frame;
    [self loadHighResPicForPhotoObject:_photos[indexPath.row]];
    [self zoomToFullScreen:YES];

}

- (void)zoomOut:(UITapGestureRecognizer *)recognizer
{
    [self zoomToFullScreen:NO];
}

- (void)zoomToFullScreen:(BOOL)fullscreen
{
        [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
            //hier sollte das format des bildes nicht verzogen werden
            if (fullscreen) {
                [_imageView setFrame:[[UIScreen mainScreen] bounds]];
            } else {
                [_imageView setFrame:prevFrame];
            }
        }completion:^(BOOL finished){
            if (!fullscreen){
                [_imageView removeFromSuperview];
            }
        }];
}
- (void)loadHighResPicForPhotoObject:(NXPhotoObject *)object
{
    //diese methoden sollten auf dem object implementiert werden mit imagecache

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:object.highResImageUrl]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_imageView setImage:image];
            [_imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
