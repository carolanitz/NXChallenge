#import "NXPhotoViewController.h"
#import "NXPhotoCell.h"
#import "NXPhotoObject.h"
#import "NXApi.h"

@interface NXPhotoViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerRestoration,UIDataSourceModelAssociation>

@end

static const CGFloat kMinimumLineSpacing = 10.0;

@implementation NXPhotoViewController
{
    UICollectionView *_collectionView;
    NSMutableArray *_photos;
    UIImageView *_imageView;
    CGRect prevFrame;
    UIView *_backgroundView;
    UICollectionViewFlowLayout *_flowLayout;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.restorationIdentifier = @"photoViewController";
        self.restorationClass = [self class];
        _photos = [NSMutableArray new];
        _imageView = [UIImageView new];
        _imageView.restorationIdentifier = @"imageView";
        self.navigationItem.title = @"Browse";
        [self setupCollectionView];
        [self fetchPhotos];
        [self setupBackgroundView];
    }
    return self;
}

- (void)fetchPhotos
{
    [[NXApi sharedAPI] getUserPhotosWithCallback:^(NSArray *array, NSError *error) {
        if (error != nil){
            //localize
            [[[UIAlertView alloc] initWithTitle:@"Fail!" message:[NSString stringWithFormat:@"couldn't load data \n error:%@",error.localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
            return;
        }
        for (id object in array) {
            NXPhotoObject *photoObject = [[NXPhotoObject alloc] initWithJSONObject:object];
            if(photoObject)
                [_photos addObject:photoObject];
        }
        [_collectionView reloadData];
    }];
}

- (void)setupBackgroundView
{
    _backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    _backgroundView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut:)];
    [_backgroundView addGestureRecognizer:tapGestureRecognizer];
    [_backgroundView setUserInteractionEnabled:YES];
    _backgroundView.restorationIdentifier = @"backgroundView";
}

- (void)setupCollectionView
{
    _flowLayout = [UICollectionViewFlowLayout new];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:_flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.restorationIdentifier = @"collectionView";
    [_collectionView registerClass:[NXPhotoCell class] forCellWithReuseIdentifier:@"NXPhotoCell"];
    [self.view addSubview:_collectionView];
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return CGSizeMake(self.view.frame.size.width /2.0 - 5, self.view.frame.size.width /2.0 - 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kMinimumLineSpacing;
}

#pragma mark - collectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     NXPhotoCell *photocell = (NXPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    _imageView.image = photocell.imageView.image;

    //calculate and set the frame from where the imageview should be animated

    CGPoint origin = [self.view convertPoint:photocell.imageView.frame.origin fromView:photocell];
    CGRect photocellRect =  CGRectMake(origin.x, origin.y, photocell.imageView.bounds.size.width, photocell.imageView.bounds.size.height);
    _imageView.frame = photocellRect;
    prevFrame = photocellRect;

    //loadingHighResolutionImage for object

    NXPhotoObject *object = _photos[indexPath.row];
    [object loadHighResPicture:^(UIImage *image) {
        [_imageView setImage:image];
    }];
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
            CGSize viewSize = self.view.frame.size;
            CGFloat scale = viewSize.width / _imageView.frame.size.width;
            CGFloat originY = (viewSize.height - _imageView.frame.size.height * scale) / 2;
            CGRect newFrame = CGRectMake(0.0, originY, viewSize.width, _imageView.frame.size.height * scale);

            [self.view addSubview:_imageView];
            [self.view bringSubviewToFront:_imageView];
            [self.view insertSubview:_backgroundView belowSubview:_imageView];
            [_imageView setFrame:newFrame];
        } else {
            [_imageView setFrame:prevFrame];
        }
        _backgroundView.alpha = fullscreen ? 0.8 : 0.0;
    }completion:^(BOOL finished) {
        if (!fullscreen) {
            [_backgroundView removeFromSuperview];
            [_imageView removeFromSuperview];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.restorationIdentifier = @"photoview";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[self alloc] initWithNibName:nil bundle:nil];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_imageView forKey:@"imageView"];
   // [coder encodeObject:_photos forKey:@"photos"];
    [coder encodeObject:_backgroundView forKey:@"backgroundView"];
    [coder encodeObject:_collectionView forKey:@"collectionView"];
    [coder encodeObject:self.view forKey:@"photoview"];
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    //hierfür hätte ich das protocol auf NXPhotoObject implementieren müssen
   // _photos = [coder decodeObjectForKey:@"photos"];
    _imageView = [coder decodeObjectForKey:@"imageView"];
    _backgroundView = [coder decodeObjectForKey:@"backgroundView"];
    _collectionView = [coder decodeObjectForKey:@"collectionView"];
    self.view = [coder decodeObjectForKey:@"photoview"];
    [super decodeRestorableStateWithCoder:coder];
}

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view
{
    NSString *identifier = nil;
    if (idx && view)
    {
        NXPhotoObject *photo = [_photos objectAtIndex:idx.row];
        //sollte natürlich nicht die caption sein, sondern ein identifier der auch ins photoobject geladen werden müsste
        identifier = photo.caption;
    }
    return identifier;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
    NSIndexPath *indexPath = nil;
    if (identifier && view)
    {
        for(int i = 0; i < _photos.count; i++){
            NXPhotoObject *photo = _photos[i];
            if([photo.caption isEqualToString:identifier]){
                indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            }
        }
    }
    [_collectionView reloadData];
    
    return indexPath;
}

@end
