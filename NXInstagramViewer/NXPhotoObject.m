
#import "NXPhotoObject.h"

@implementation NXPhotoObject

- (instancetype)initWithJSONObject:(NSDictionary *)JSONObject
{
    if (![JSONObject isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        //here should be a lot more errorchecking
        NSArray *array = JSONObject[@"caption"];
        if (![array isEqual:[NSNull null]]) {
            _caption = JSONObject[@"caption"][@"text"];
        }
        array = JSONObject[@"likes"];
        if (![array isEqual:[NSNull null]]) {
            _likes = JSONObject[@"likes"][@"count"];
        }

        array = JSONObject[@"location"];
        if (![array isEqual:[NSNull null]]) {
            _location = JSONObject[@"location"][@"name"];
        }
        _lowResImageUrl = [NSURL URLWithString:JSONObject[@"images"][@"thumbnail"][@"url"]];
        _highResImageUrl = [NSURL URLWithString:JSONObject[@"images"][@"standard_resolution"][@"url"]];
    }
    return self;
}

@end
