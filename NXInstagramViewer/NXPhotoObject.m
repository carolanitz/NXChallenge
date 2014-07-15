
#import "NXPhotoObject.h"

@implementation NXPhotoObject
{
    UIImage *_lowResPicture;
    UIImage *_highResPicture;
}

- (instancetype)initWithJSONObject:(NSDictionary *)JSONObject
{
    if (![JSONObject isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        
        NSArray *array = JSONObject[@"caption"];
        if (![array isEqual:[NSNull null]]) {
            _caption = [self stringForJSONObject:JSONObject[@"caption"][@"text"]];
        }
        array = JSONObject[@"likes"];
        if (![array isEqual:[NSNull null]]) {
            if ([JSONObject[@"likes"][@"count"] isKindOfClass:[NSNumber class]]) {
                _likes = JSONObject[@"likes"][@"count"];
            }
        }
        array = JSONObject[@"location"];
        if (![array isEqual:[NSNull null]]) {
            _location = [self stringForJSONObject:JSONObject[@"location"][@"name"]];
        }
        //here should be more error testing
        _lowResImageUrl = [NSURL URLWithString:JSONObject[@"images"][@"thumbnail"][@"url"]];
        _highResImageUrl = [NSURL URLWithString:JSONObject[@"images"][@"standard_resolution"][@"url"]];
    }
    return self;
}

- (void)loadLowResPicture:(void (^)(UIImage *image))callback
{
    [self loadPictureWithHighRes:NO callback:callback];
}

- (void)loadHighResPicture:(void (^)(UIImage *image))callback
{
    [self loadPictureWithHighRes:YES callback:callback];
}

- (void)loadPictureWithHighRes:(BOOL)high callback:(void (^)(UIImage *image))callback
{
    UIImage *picture = high ? _highResPicture : _lowResPicture;
    NSURL *imageURL = high ? _highResImageUrl : _lowResImageUrl;
    if (picture) {
        callback(picture);
        return;
    } else {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (high) {
                    _highResPicture = image;
                } else {
                    _lowResPicture = image;
                }
                callback(image);
            });
        });
    }
}

- (NSString *)stringForJSONObject:(id)JSONObject
{
    if (![JSONObject isKindOfClass:[NSString class]]) return nil;

    return JSONObject;
}
@end
