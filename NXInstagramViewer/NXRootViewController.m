#import "NXRootViewController.h"
#import <NXOAuth2Client/NXOAuth2AccountStore.h>
#import "NXPhotoViewController.h"

@interface NXRootViewController ()

@end

@implementation NXRootViewController
{
    UITextField *emailTextfield;
    UITextField *passwordTextfield;
    UIButton *login;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupEmailTextfield];
    [self setupPasswordTextfield];
    [self setupLoginButton];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      NXPhotoViewController *collectionView = [NXPhotoViewController new];
                                                      [self.navigationController pushViewController:collectionView animated:YES];
                                                      //
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

- (void)setupEmailTextfield
{
    emailTextfield = [UITextField new];
    emailTextfield.translatesAutoresizingMaskIntoConstraints = NO;
    [emailTextfield setPlaceholder:NSLocalizedString(@"email", nil)];
    emailTextfield.backgroundColor = [UIColor whiteColor];
    [emailTextfield setText: @"nitz.carola@googlemail.com"];
    [self.view addSubview:emailTextfield];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:emailTextfield attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|->=0-[emailTextfield(>=300)]->=0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(emailTextfield)]];
}

- (void)setupPasswordTextfield
{
    //viel duplication zwischen email und passwortfield sollte in setupTextfield rausgezogen werden

    passwordTextfield = [UITextField new];
    passwordTextfield.translatesAutoresizingMaskIntoConstraints = NO;
    passwordTextfield.secureTextEntry = YES;
    [passwordTextfield setPlaceholder:NSLocalizedString(@"password", nil)];
    passwordTextfield.backgroundColor = [UIColor whiteColor];
    [passwordTextfield setText: @"test123"];
    [self.view addSubview:passwordTextfield];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passwordTextfield attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    // 300 sollte als static rausgezogen werden und als metric reingegeben werden
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|->=0-[passwordTextfield(>=300)]->=0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(passwordTextfield)]];
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
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[emailTextfield]-[passwordTextfield]-[login]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(emailTextfield, passwordTextfield, login)]];
}

- (void)login
{
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"thisisatest"
                                                              username:emailTextfield.text
                                                              password:passwordTextfield.text];
}

@end
