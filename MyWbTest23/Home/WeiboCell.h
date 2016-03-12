//
//  WeiboCell.h
//  MyWbTest23
//
//  Created by Apple on 16/2/28.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboModel;
@class WeiboView;

@interface WeiboCell : UITableViewCell{
    UIImageView     *_userImage;    //用户头像视图
    UILabel         *_nickLabel;    //昵称
    UILabel         *_repostCountLabel; //转发数
    UILabel         *_commentLabel;     //回复数
    UILabel         *_sourceLabel;      //发布来源
    UILabel         *_createLabel;      //发布时间
}

@property (nonatomic, strong) WeiboModel *weiboModel;
@property (nonatomic, strong) WeiboView *weiboView;

@end
