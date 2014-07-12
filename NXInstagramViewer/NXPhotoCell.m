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
    UIImageView *_imageView;
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
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
    [self.contentView addSubview:_imageView];
}

- (void)setupLocationLabel
{
    _location = [self setupLabel];
}

- (void)setupCaptionLabel
{
    _caption = [self setupLabel];
}

- (void)setupLikesLabel
{
    _likes = [self setupLabel];
}

- (UILabel *)setupLabel
{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:label];
    return label;
}

//- updateWithphotoItem:(NXPhotoItem *)item
//{
//
//}
@end
