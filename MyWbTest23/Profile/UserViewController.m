//
//  UserViewController.m
//  MyWbTest23
//
//  Created by Apple on 16/3/11.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "UserViewController.h"
#import "WeiboTableView.h"
#import "UserInfoView.h"

@interface UserViewController ()
@property (weak, nonatomic) IBOutlet WeiboTableView *tableView;

@end

@implementation UserViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIButton *homeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [homeBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_home"]]];
        [homeBtn addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeBtn];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UserInfoView *userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    self.title = @"个人资料";
    [self.view addSubview:userInfoView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goHome{
    
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
