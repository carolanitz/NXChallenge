#import <Foundation/Foundation.h>

@interface NXApi : NSObject

+ (NXApi *)sharedAPI;

- (void)handleURL:(NSURL *)url;

- (void)initialize;

- (void)getUserPhotosWithCallback:(void (^)(NSArray *array, NSError *error))callback;

- (BOOL)userIsLoggedIn;

- (void)login;

@end
