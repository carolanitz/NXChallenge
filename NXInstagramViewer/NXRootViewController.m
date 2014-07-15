#import "NXRootViewController.h"
#import <NXOAuth2Client/NXOAuth2AccountStore.h>
#import "NXPhotoViewController.h"
#import "NXApi.h"

@interface NXRootViewController ()

@end

@implementation NXRootViewController
{
    UIButton *login;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Hier sollte natürlich eine fancy UI sein die genau erklärt, warum der User sich jetzt einloggen soll.
    // und in der UI wird der LoginButton eingebettet

    [self setupLoginButton];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      NXPhotoViewController *collectionView = [NXPhotoViewController new];
                                                      [self.navigationController setViewControllers:@[collectionView]];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
                                                      //should be localized
                                                      [[[UIAlertView alloc] initWithTitle:@"Login failed" message:[NSString stringWithFormat:@"username or password is incorrect \n error:%@",error.localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
                                                  }];
}

- (void)setupLoginButton
{
    login = [UIButton new];
    [login setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateNormal];
    login.translatesAutoresizingMaskIntoConstraints = NO;
    [login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:login attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:login attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

- (void)login
{
    [[NXApi sharedAPI] login];
}

@end
