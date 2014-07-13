//
//  NXphotoCell.m
//  NXInstagramViewer
//
//  Created by Carola Nitz on 12/07/14.
//  Copyright (c) 2014 nxtbgthng. All rights reserved.
//

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
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView][_caption][_likes][_location]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_caption, _imageView,_likes,_location)]];

    }
    return self;
}

- (void)setupImageView
{
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
}

- (void)setupLocationLabel
{
    _location = [self setupLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_location attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_location attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
}

- (void)setupCaptionLabel
{
    _caption = [self setupLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_caption attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_caption attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
}

- (void)setupLikesLabel
{
    _likes = [self setupLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_likes attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_likes attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
}

- (UILabel *)setupLabel
{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.numberOfLines = 0;
    [self.contentView addSubview:label];
    return label;
}

- (void)updateWithPhotoObject:(NXPhotoObject *)object
{
    _caption.text = object.caption;
    _likes.text = [NSString stringWithFormat:@"Likes:%@",object.likes];
    if (object.location) {
        _location.text = [NSString stringWithFormat:@"Location:%@",object.location];
    }

    //at this part an imageCache should be used to not always load the picture
    //and an activityindicator should be shown as well
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:object.lowResImageUrl]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_imageView setImage:image];
            [_imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
            //[self setNeedsLayout];
            [self layoutIfNeeded];
        });
    });
}
@end
