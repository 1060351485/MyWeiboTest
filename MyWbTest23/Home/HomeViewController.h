//
//  HomeViewController.h
//  MyWbTest23
//
//  Created by Apple on 16/2/23.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"
#import "ThemeImageView.h"

@interface HomeViewController : BaseViewController{
    ThemeImageView *barView;
}

@property (strong, nonatomic) WeiboTableView *weiboTableView;

@property (nonatomic, copy) NSString *topWeiboID;

@property (nonatomic, copy) NSString *lastWeiboID;

@property (nonatomic, strong) NSMutableArray *weibosData;


- (void)refreshWeibo;
- (void)loadWeiboData;


@end
