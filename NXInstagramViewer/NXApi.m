#import "NXApi.h"
#import <NXOAuth2Client/NXOAuth2Request.h>
#import <NXOAuth2Client/NXOAuth2AccountStore.h>
#import <NXOAuth2Client/NXOAuth2Account.h>
#import <NXOAuth2Client/NXOAuth2AccessToken.h>

@implementation NXApi

+(NXApi *)sharedAPI
{
    static NXApi *sharedAPI;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAPI = [[self alloc] init];
    });
    return sharedAPI;
}

- (void)initialize
{
    [[NXOAuth2AccountStore sharedStore] setClientID:@"f2c4524d19ea48e89d83423ee0971142"
                                             secret:@"e239b3d2d2ef4baf9d7ada94164cbd08"
                                              scope:[NSSet setWithObjects:@"basic",@"likes", @"relationships", @"comments", nil]
                                   authorizationURL:[NSURL URLWithString:@"https://api.instagram.com/oauth/authorize"]
                                           tokenURL:[NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"]
                                        redirectURL:[NSURL URLWithString:@"nxdevchallange://oauth"]
                                      keyChainGroup:@"NXinstagramViewer"
                                     forAccountType:@"thisisatest"];
}

- (void)handleURL:(NSURL*)url
{
     [[NXOAuth2AccountStore sharedStore] handleRedirectURL:url];
}

- (void)getUserPhotosWithCallback:(void (^)(NSArray *array, NSError *error))callback
{
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
                       callback(array, error);
                   }];
}

- (void)login
{
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"thisisatest"];
}

- (BOOL)userIsLoggedIn
{
    return [[NXOAuth2AccountStore sharedStore] accounts].count > 0;
}
@end
