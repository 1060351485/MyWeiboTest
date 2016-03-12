//
//  HomeViewController.m
//  MyWbTest23
//
//  Created by Apple on 16/2/23.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "HomeViewController.h"
#import "WeiboSDK.h"
#import "WBHttpRequest+WeiboUser.h"
#import "WeiboModel.h"
#import "JSONKit.h"
#import "UIFactory.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MainViewController.h"
#import "DetailViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface HomeViewController ()<WBHttpRequestDelegate, UITableViewEventDelegate>

@end

@implementation HomeViewController

#pragma mark - life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:  nibBundleOrNil];
    self.title = @"Weibo";
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *bindItem = [[UIBarButtonItem alloc] initWithTitle:@"绑定账号" style:UIBarButtonItemStylePlain target:self action:@selector(bindAction:)];
    self.navigationItem.rightBarButtonItem = bindItem;
    
    UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logoutAction:)];
    self.navigationItem.leftBarButtonItem = logoutItem;
    
    _weiboTableView = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44) style:UITableViewStylePlain];
    _weiboTableView.refreshHeader = YES;
    _weiboTableView.delegate = _weiboTableView;
    _weiboTableView.delegate = _weiboTableView;

    _weiboTableView.eventDelegate = self;

    [self.view addSubview:_weiboTableView];
    
    if ([self isAuthValid]) {
        [self loadWeiboData];
    }else{
        [self bindAction:nil];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //enable slide
    if (self.mm_drawerController) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //disable slide in other view controller
    if (self.mm_drawerController) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - load data

- (void)loadWeiboData{
    
//    [self showLoading:YES];
    self.weiboTableView.hidden = YES;
    [super showHUD];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [[ud objectForKey:@"AuthData"] objectForKey:@"AccessToken"];
    NSString *url = @"https://api.weibo.com/2/statuses/home_timeline.json";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"20",@"count",nil];
    
    [WBHttpRequest requestWithAccessToken:token
                                      url:url
                               httpMethod:@"GET"
                                   params:params
                                 delegate:self
                                  withTag:@"loadData"];
}

- (void)pullUpData{
    
    if (self.lastWeiboID.length == 0) {
        NSLog(@"last微博id为空");
        return;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [[ud objectForKey:@"AuthData"] objectForKey:@"AccessToken"];
    NSString *url = @"https://api.weibo.com/2/statuses/home_timeline.json";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.lastWeiboID,@"max_id",nil];
    [WBHttpRequest requestWithAccessToken:token
                                      url:url
                               httpMethod:@"GET"
                                   params:params
                                 delegate:self
                                  withTag:@"pullUpData"];
}

- (void)pullUpDataFinish:(NSString *)result{
    NSDictionary *dict = [result objectFromJSONStringWithParseOptions:JKParseOptionStrict
                                                                error:nil];
    NSArray *statuses = [dict objectForKey:@"statuses"];
    
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:[statuses count]];
    
    for (NSDictionary *statusesDict in statuses) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statusesDict];
        [weibos addObject:weibo];
    }
    [weibos removeObjectAtIndex:0];
    if (weibos.count > 0) {
        WeiboModel *lastWeibo = (WeiboModel *)[weibos lastObject];
        self.lastWeiboID = [lastWeibo.weiboId stringValue];
        
    }
    
    [self.weibosData addObjectsFromArray:weibos];
    if (statuses.count >= 20) {
        _weiboTableView.isMore = YES;
    }else{
        _weiboTableView.isMore = NO;
    }
    
    _weiboTableView.data = self.weibosData;
    
    [_weiboTableView reloadData];
}

- (void)pullDownData{
    
    if (self.topWeiboID.length == 0) {
        NSLog(@"top微博id为空");
        return;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [[ud objectForKey:@"AuthData"] objectForKey:@"AccessToken"];
    NSString *url = @"https://api.weibo.com/2/statuses/home_timeline.json";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"20",@"count",self.topWeiboID,@"since_id",nil];
    [WBHttpRequest requestWithAccessToken:token
                                      url:url
                               httpMethod:@"GET"
                                   params:params
                                 delegate:self
                                  withTag:@"pullDownData"];
}

- (void)pullDownDataFinish:(NSString *)result{

    NSDictionary *dict = [result objectFromJSONStringWithParseOptions:JKParseOptionStrict
                                                                error:nil];
    NSArray *statuses = [dict objectForKey:@"statuses"];
    
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:[statuses count]];

    for (NSDictionary *statusesDict in statuses) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statusesDict];
        [weibos addObject:weibo];
    }
    
    if (weibos.count > 0) {
        _topWeiboID = [((WeiboModel *)[weibos objectAtIndex:0]).weiboId stringValue];
        WeiboModel *lastWeibo = (WeiboModel *)[weibos lastObject];
        self.lastWeiboID = [lastWeibo.weiboId stringValue];
    }
    [weibos addObjectsFromArray:self.weibosData];
    self.weibosData = weibos;
    _weiboTableView.data = weibos;
    
    [_weiboTableView reloadData];
    [_weiboTableView doneLoadingTableViewData];

    NSUInteger updateCount = [statuses count];
    NSLog(@"上拉加载了%lu条",(unsigned long)updateCount);
    [self showNewWeiboCount:updateCount];
}


- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"网络加载失败：%@",error);
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
    
//    [super showLoading:NO];
    [super hideHUD];
    self.weiboTableView.hidden = NO;
    
    if ([request.tag isEqualToString:@"loadData"]) {
        NSLog(@"\"loadData\"加载成功");
        
        NSDictionary *dict = [result objectFromJSONStringWithParseOptions:JKParseOptionStrict
                                                                    error:nil];
        NSArray *statuses = [dict objectForKey:@"statuses"];
        
        NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:[statuses count]];
        self.weibosData = weibos;
        for (NSDictionary *statusesDict in statuses) {
            WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statusesDict];
            [weibos addObject:weibo];
            
        }
        //    NSLog(@"%@", weibos);  不注释会报错
        if([weibos count]){
            _topWeiboID = [((WeiboModel *)[weibos objectAtIndex:0]).weiboId stringValue];
            
            WeiboModel *lastWeibo = (WeiboModel *)[weibos lastObject];
            self.lastWeiboID = [lastWeibo.weiboId stringValue];
        }
        _weiboTableView.data = weibos;
        [_weiboTableView reloadData];
        
    }else
        if ([request.tag isEqualToString:@"pullDownData"]){
            
            NSLog(@"\"pullDownData\"加载成功");
            [self pullDownDataFinish:result];
            
        }else if ([request.tag isEqualToString:@"pullUpData"]){
            
            NSLog(@"\"pullUpData\"加载成功");
            [self pullUpDataFinish:result];
        }
}

- (void)refreshWeibo{
    _weiboTableView.hidden = NO;
    [_weiboTableView refreshData];
    [self pullDownData];
}


#pragma mark - loaded weibo count
- (void)showNewWeiboCount:(NSUInteger)count{
    if(!barView){
        barView = [UIFactory createImageView:@"timeline_new_status_background.png"];
        UIImage *image = [barView.image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        barView.image = image;
        barView.leftCapWidth = 5;
        barView.topCapHeight = 5;
        barView.frame = CGRectMake(5, -40, ScreenWidth-10, 40);
        [self.view addSubview:barView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.tag = 2021;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [barView addSubview:label];
    }
    if (count > 0) {
        UILabel *label = (UILabel *)[barView viewWithTag:2021];
        label.text = [NSString stringWithFormat:@"%lu条新微博",(unsigned long)count];
        [label sizeToFit];
        label.origin = CGPointMake((barView.width-label.width)/2, (barView.height-label.height)/2);
        
        [UIView animateWithDuration:0.5 animations:^{
            barView.top = 5;
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:1.0];
                [UIView setAnimationDuration:0.5];
                barView.top = -40;
                [UIView commitAnimations];
            }
        }];
        
        //播放提示音
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *fileUrl = [NSURL URLWithString:filePath];
        SystemSoundID soundId;
        AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(fileUrl), &soundId);
        AudioServicesPlaySystemSound(soundId);
    }
    
    [(MainViewController *)self.tabBarController showBadge:NO];
}

#pragma mark - login logout

- (void)bindAction:(UIBarButtonItem *)btnItem{

    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"HomeViewController1",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)logoutAction:(UIBarButtonItem *)btnItem{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *authData = [userDefaults objectForKey:@"AuthData"];
    if(authData){
        NSString *token = [authData objectForKey:@"AccessToken"];
        [WeiboSDK logOutWithToken:token delegate:self withTag:@"user1"];
        NSLog(@"登出！Logout,%@",token);
        [userDefaults removeObjectForKey:@"AuthData"];
        [userDefaults synchronize];
    }
}

#pragma mark - user valid

- (BOOL)isAuthValid
{
    return ([self isLoggedIn] && ![self isAuthorizeExpired]);
}

- (BOOL)isLoggedIn
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *authData = [userDefaults objectForKey:@"AuthData"];
    if(authData){
        NSString *userId = [authData objectForKey:@"UserId"];
        NSString *token = [authData objectForKey:@"AccessToken"];
        NSDate *date = [authData objectForKey:@"ExpireDate"];
        return userId && token && date;
    }
    return false;
}

- (BOOL)isAuthorizeExpired
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *authData = [userDefaults objectForKey:@"AuthData"];
    if(authData){
        NSDate *date = [authData objectForKey:@"ExpireDate"];
        NSDate *now = [NSDate date];
        return ([now compare:date] == NSOrderedDescending);
    }
    return false;
}

#pragma mark - tableView event delegate

- (void)pullDown:(BaseTableView *)tableView{
    [self pullDownData];
}

-(void)pullUp:(BaseTableView *)tableView{
    NSLog(@"上拉");
    [self pullUpData];
}

- (void)tableView:( BaseTableView * _Nonnull )tableView selectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath{
    NSLog(@"选中cell");
    WeiboModel *weiboModel = [self.weibosData objectAtIndex:indexPath.row];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.weiboModel = weiboModel;
    [self.navigationController pushViewController:detailVC animated:YES];
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
