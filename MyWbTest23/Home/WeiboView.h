//
//  WeiboView.h
//  MyWbTest23
//
//  Created by Apple on 16/2/28.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "RTLabel.h"
#import "ThemeImageView.h"

#define kWeiboWidthList (360-60)
#define kWeiboWidthDetail (300)

@interface WeiboView : UIView<RTLabelDelegate>{
    @private
    RTLabel *_textLabel;
    UIImageView *_image;
    ThemeImageView *_repostBackgroundView;
    NSMutableString *_parseText;
}

@property (nonatomic, strong) WeiboModel *weiboModel;
@property (nonatomic, strong) WeiboView *repostView;
@property (nonatomic) BOOL isRepost;
@property (nonatomic) BOOL isDetail;

+ (float)getFontSize:(BOOL)isDetail isRepost:(BOOL)isRepost;

+ (CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel isRepost:(BOOL)isRepost isDetail:(BOOL)isDetail;

@end
