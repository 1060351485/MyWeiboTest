//
//  BaseViewController.m
//  MyWbTest23
//
//  Created by Apple on 16/2/23.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "BaseViewController.h"
#import "UIFactory.h"

@interface BaseViewController ()



@end

@implementation BaseViewController

@synthesize haveBackBtn;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.haveBackBtn = YES;
        
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    [super setTitle:title];
    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    UILabel *titleLabel = [UIFactory createLabel:kNavigationBarTitleLabel];
//    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && haveBackBtn) {
        UIButton *btn = [UIFactory createButton:@"navigationbar_back" highlighted:@"navigationbar_back_highlighted"];
        btn.frame = CGRectMake(0, 0, 24, 24);
        [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = btnItem;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button action
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showLoading:(BOOL)show{
    if (!_loading) {
        _loading = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight/2-80, ScreenWidth, 20)];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [indicator startAnimating];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"正在加载";
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textColor = [UIColor blackColor];
        [label sizeToFit];
        
        label.left = (ScreenWidth - label.width)/2;
        indicator.right = label.left-5;
        
        [_loading addSubview:label];
        [_loading addSubview:indicator];
    }
    
    if (show) {
        if (![_loading superview]) {
            [self.view addSubview:_loading];
        }
    }else{
        [_loading removeFromSuperview];
    }
}

- (void)showHUD{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    self.hud.dimBackground = YES;
}
- (void)hideHUD{
    [self.hud hide:YES];
}

- (void)showHUD:(NSString *)title isDim:(BOOL)isDim{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = isDim;
    self.hud.labelText = title;
}

//- (void)showHUDComplete:(NSString *)complete{
//    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:]];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
