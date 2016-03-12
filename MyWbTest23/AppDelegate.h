//
//  AppDelegate.h
//  MyWbTest23
//
//  Created by Apple on 16/2/23.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "MainViewController.h"
#import "WeiboSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSString* wbtoken;
    NSString* wbCurrentUserID;
}

@property (strong, nonatomic) UIWindow *window;
//@property (nonatomic, strong) MainViewController *mainVC;

@end

