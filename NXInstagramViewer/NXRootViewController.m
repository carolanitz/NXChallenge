#import "NXRootViewController.h"
#import <NXOAuth2Client/NXOAuth2AccountStore.h>
#import "NXPhotoViewController.h"
#import "NXApi.h"

@interface NXRootViewController () <UIViewControllerRestoration>

@end

@implementation NXRootViewController
{
    UIButton *login;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.restorationIdentifier = @"rootViewController";
        self.restorationClass = [self class];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.restorationIdentifier = @"LoginView";
    // Hier sollte natürlich eine fancy UI sein die genau erklärt, warum der User sich jetzt einloggen soll.
    // und in der UI wird der LoginButton eingebettet

    [self setupLoginButton];
    self.navigationItem.title = @"Login";

    self.view.backgroundColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      NXPhotoViewController *collectionView = [NXPhotoViewController new];
                                                      [self.navigationController pushViewController:collectionView animated:YES];
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
    login.translatesAutoresizingMaskIntoConstraints = NO;
    [login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [login setBackgroundImage:[UIImage imageNamed:@"Instagram_normal"] forState:UIControlStateNormal];
    [self.view addSubview:login];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:login attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:login attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [self new];
}

- (void)login
{
    [[NXApi sharedAPI] login];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.view forKey:@"LoginView"];
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    self.view = [coder decodeObjectForKey:@"LoginView"];
    [super decodeRestorableStateWithCoder:coder];
}

@end
