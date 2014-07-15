
#import <UIKit/UIKit.h>
#import "NXPhotoObject.h"

@interface NXPhotoCell : UICollectionViewCell

- (void)updateWithPhotoObject:(NXPhotoObject *)object;

@property (nonatomic, readonly) UIImageView *imageView;

@end
