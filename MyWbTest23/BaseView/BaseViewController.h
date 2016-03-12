//
//  BaseViewController.h
//  MyWbTest23
//
//  Created by Apple on 16/2/23.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController{

    UIView *_loading;

}

@property (nonatomic, assign) BOOL haveBackBtn;
@property (nonatomic, strong) MBProgressHUD *hud;

- (void)showLoading:(BOOL)show;
- (void)showHUD;
- (void)showHUD:(NSString *)title isDim:(BOOL)isDim;
- (void)showHUDComplete:(NSString *)complete;
- (void)hideHUD;

@end
