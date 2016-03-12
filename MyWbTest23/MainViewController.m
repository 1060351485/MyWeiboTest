//
//  MainViewController.m
//  MyWbTest23
//
//  Created by Apple on 16/2/23.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"
#import "DiscoverViewController.h"
#import "MoreViewController.h"
#import "BaseNavigationController.h"
#import "UIFactory.h"
#import "ThemeManager.h"
#import "WeiboModel.h"
#import "WBHttpRequest.h"
#import "UIViewExt.h"

@interface MainViewController ()<WBHttpRequestDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (nonatomic) NSDate *wbExpireDate;

@property (nonatomic, strong) HomeViewController *homeVC;

@end

@implementation MainViewController


@synthesize wbtoken;
@synthesize wbCurrentUserID;
@synthesize wbRefreshToken;
@synthesize wbExpireDate;
@synthesize homeVC;

#pragma mark - Weibo Delegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
//    NSLog(@"!!!request : %@", (NSString *)(request.userInfo));
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
        self.wbExpireDate = [(WBAuthorizeResponse *)response expirationDate];
        
        NSDictionary *userData = [NSDictionary dictionaryWithObjectsAndKeys:
                                  self.wbtoken,@"AccessToken",
                                  self.wbCurrentUserID,@"UserId",
                                  self.wbRefreshToken,@"RefreshToken",
                                  self.wbExpireDate,@"ExpireDate",nil];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:userData forKey:@"AuthData"];
        [userDefaults synchronize];
        
        [homeVC loadWeiboData];
        NSLog(@"认证：%@", message);
    }
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data{
    if ([request.tag isEqualToString:@"updateRefreshBadge"]) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [self unreadViewRefresh:dict];
    }
}

#pragma mark - navigation controller delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    NSUInteger n =[navigationController.viewControllers count];
    
    // controllers on the stack
    if (n == 2) {
        [self showTabBar:NO];
    }else if( n == 1 ){
        [self showTabBar:YES];
    }
    
}

#pragma mark - init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBar setHidden:TRUE];
    }
    
    return self;
}

- (void)_initTabBarView{
    _tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49, ScreenWidth, 49)];
//    [_tabBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]]];
    
    UIImageView *tabBarImageView = [UIFactory createImageView:@"tabbar_background.png"];
    tabBarImageView.frame = _tabBarView.bounds;
    
    [_tabBarView addSubview:tabBarImageView];
    
    NSArray *bgImage = @[@"tabbar_home.png", @"tabbar_message_center.png", @"tabbar_profile.png", @"tabbar_discover.png", @"tabbar_more.png"];
    NSArray *highlightBgImage = @[@"tabbar_home_highlighted.png", @"tabbar_message_center_highlighted.png", @"tabbar_profile_highlighted.png", @"tabbar_discover_highlighted.png", @"tabbar_more_highlighted.png"];
    
    for (int i = 0; i < bgImage.count; i++) {
        NSString *bg = bgImage[i];
        NSString *hbg = highlightBgImage[i];
        
//        ThemeButton *btn = [[ThemeButton alloc] initWithImage:bg highlightedImage:hbg];
        UIButton *btn = [UIFactory createButton:bg highlighted:hbg];
        btn.showsTouchWhenHighlighted = YES;
        btn.frame = CGRectMake((ScreenWidth/5-30)/2 + i*ScreenWidth/5, (49-30)/2, 30, 30);
        btn.tag = i;

        [btn addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBarView addSubview:btn];
        
    }
    [self.view addSubview:_tabBarView];
    _tabbarSlider = [UIFactory createImageView:@"tabbar_slider.png"];
    _tabbarSlider.backgroundColor = [UIColor clearColor];
    _tabbarSlider.frame = CGRectMake((ScreenWidth/5-20)/2, 5, 15, 44);
    [_tabBarView addSubview:_tabbarSlider];
}

- (void)_initViewController{
    homeVC = [[HomeViewController alloc] init];
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    DiscoverViewController *discoverVC = [[DiscoverViewController alloc] init];
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    
    NSArray *views = @[homeVC, messageVC, profileVC, discoverVC, moreVC];
    NSMutableArray *navViews = [NSMutableArray arrayWithCapacity:5];
    for (UIViewController *vc in views) {
        BaseNavigationController *baseNC = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [navViews addObject:baseNC];
        baseNC.delegate = self;
    }
    
    self.viewControllers = navViews;
}

#pragma mark - action

- (void)selectTab:(UIButton *)button{
    float x = button.left + button.width - _tabbarSlider.width;
    [UIView animateWithDuration:0.2 animations:^{
        _tabbarSlider.left = x;
    }];
    
    if (button.tag == self.selectedIndex && button.tag == 0) {
        [homeVC refreshWeibo];
    }
    
    self.selectedIndex = button.tag;
}

- (void)timerAction:(NSTimer *)timer{
    [self loadUnreadData];
}

- (void)showBadge:(BOOL)show{
    _badgeView.hidden = show;
}

- (void)showTabBar:(BOOL)show{
    [UIView animateWithDuration:0.2 animations:^{
        if (show) {
            _tabBarView.left = 0;
            
        }else{
            _tabBarView.left = -ScreenWidth;
        }
    }];
    [self resetViewSize:show];
}

- (void)resetViewSize:(BOOL)show{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITransitionView")]) {
            if (show) {
                subView.height = ScreenHeight - 49 - 20;
            }else{
                subView.height = ScreenHeight - 150;
            }
        }
    }
}

- (void)loadUnreadData{

    NSString *url = @"https://rm.api.weibo.com/2/remind/unread_count.json";
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [[ud objectForKey:@"AuthData"] objectForKey:@"AccessToken"];
    self.wbtoken = token;

    [WBHttpRequest requestWithAccessToken:token url:url httpMethod:@"GET" params:nil delegate:self withTag:@"updateRefreshBadge"];

}

- (void)unreadViewRefresh:(NSDictionary *)result{
    NSNumber * status= [result objectForKey:@"status"];
    NSLog(@"更新微博数：status = %@",status);
    if (!_badgeView) {
        _badgeView = [UIFactory createImageView:@"main_badge.png"];
        _badgeView.frame = CGRectMake(ScreenWidth/5-25, 5, 20, 20);
        [_tabBarView addSubview:_badgeView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:_badgeView.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textColor = [UIColor purpleColor];
        label.tag = 1000;
        [_badgeView addSubview:label];
    }
    int n = [status intValue];
    if (n > 0) {
        UILabel *label = (UILabel *)[_badgeView viewWithTag:1000];
        if (n > 99) {
            n = 99;
        }
        label.text = [NSString stringWithFormat:@"%d", n];
        _badgeView.hidden = NO;
    }else{
        _badgeView.hidden = YES;
    }
    
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initViewController];
    [self _initTabBarView];
    
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
