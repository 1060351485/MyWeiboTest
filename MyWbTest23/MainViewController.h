//
//  MainViewController.h
//  MyWbTest23
//
//  Created by Apple on 16/2/23.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"

@class ThemeImageView;

@interface MainViewController : UITabBarController<WeiboSDKDelegate>{
    UIView *_tabBarView;
    UIImageView *_tabbarSlider;
    UIImageView *_badgeView;
}

- (void)showBadge:(BOOL)show;
- (void)showTabBar:(BOOL)show;

@end
