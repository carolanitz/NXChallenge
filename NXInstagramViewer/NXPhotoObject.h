#import <Foundation/Foundation.h>

@interface NXPhotoObject : NSObject

@property (nonatomic, readonly) NSString *caption;
@property (nonatomic, readonly) NSString *location;
@property (nonatomic, readonly) NSString *likes;
@property (nonatomic, readonly) NSURL *lowResImageUrl;
@property (nonatomic, readonly) NSURL *highResImageUrl;

- (instancetype)initWithJSONObject:(NSDictionary *)JSONObject;

- (void)loadLowResPicture:(void (^)(UIImage *image))callback;

- (void)loadHighResPicture:(void (^)(UIImage *image))callback;

@end
