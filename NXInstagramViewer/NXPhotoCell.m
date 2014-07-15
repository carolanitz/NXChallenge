#import "NXPhotoCell.h"

@implementation NXPhotoCell
{
    UILabel *_caption;
    UILabel *_likes;
    UILabel *_location;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
        [self setupLocationLabel];
        [self setupCaptionLabel];
        [self setupLikesLabel];
    }
    return self;
}

- (void)setupImageView
{
    _imageView = [[UIImageView alloc] init];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_imageView];
    [self.contentView sendSubviewToBack:_imageView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
}

- (void)setupLocationLabel
{
    _location = [self setupLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_location attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_location attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_location attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
}

- (void)setupCaptionLabel
{
    _caption = [self setupLabel];
    _caption.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _caption.textAlignment = NSTextAlignmentCenter;
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_caption attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_caption attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_caption attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
}

- (void)setupLikesLabel
{
    _likes = [self setupLabel];
    _likes.textAlignment = NSTextAlignmentRight;
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_likes attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_likes attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_likes attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
}

- (UILabel *)setupLabel
{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(1.0, 1.0);
    label.shadowColor = [UIColor blackColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.numberOfLines = 0;
    [self.contentView addSubview:label];
    return label;
}

- (void)updateWithPhotoObject:(NXPhotoObject *)object
{
    _caption.text = object.caption;
    _likes.text = [NSString stringWithFormat:@"❤️%@",object.likes];
    if (object.location) {
        _location.text = [NSString stringWithFormat:@"🌏%@",object.location];
    }
    [object loadLowResPicture:^(UIImage *image) {
        [_imageView setImage:image];
        [self layoutIfNeeded];
    }];

}
@end
