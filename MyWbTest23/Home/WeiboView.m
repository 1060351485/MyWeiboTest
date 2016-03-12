//
//  WeiboView.m
//  MyWbTest23
//
//  Created by Apple on 16/2/28.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "WeiboView.h"
#import "UIFactory.h"
#import "UIImageView+WebCache.h"
#import "ThemeImageView.h"
#import "UIUtils.h"
#import "NSString+URLEncoding.h"
#import "UIView+GetController.h"
#import "UserViewController.h"

#define LIST_FONT   14.0f           //列表中文本字体
#define LIST_REPOST_FONT  13.0f;    //列表中转发的文本字体
#define DETAIL_FONT  18.0f          //详情的文本字体
#define DETAIL_REPOST_FONT 17.0f    //详情中转发的文本字体

@implementation WeiboView

#pragma mark - set

- (void)setWeiboModel:(WeiboModel *)weiboModel{
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
//        NSLog(@"%p--%p",_weiboModel,weiboModel);
        
    }
    if (_repostView == nil) {
        _repostView = [[WeiboView alloc] initWithFrame:CGRectZero];
        _repostView.isRepost = YES;
        _repostView.isDetail = self.isDetail;
        [self addSubview:_repostView];
    }
    
    [self parseLink];
}

- (void)parseLink{
    
    [_parseText setString:@""];
    
    if (_isRepost) {
        NSString *nickName = _weiboModel.user.screen_name;
        NSString *encodeName = [nickName URLEncodedString];
        [_parseText appendFormat:@"<a href='user://%@'>%@</a>:",encodeName,nickName];
    }
    
    NSString *text = _weiboModel.text;
    text = [UIUtils parseLink:text];
    [_parseText appendString:text];
}

+ (CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel isRepost:(BOOL)isRepost isDetail:(BOOL)isDetail{
    
    float height = 0;
    
    RTLabel *textLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    textLabel.font = [UIFont systemFontOfSize:[WeiboView getFontSize:isDetail isRepost:isRepost]];
    
    // weibo pic height
    if (isDetail) {
        textLabel.width = kWeiboWidthDetail;
        
        NSString *bmiddleImage = weiboModel.bmiddleImage;
        if (bmiddleImage != nil && ![@"" isEqualToString:bmiddleImage]) {
            height += (200+10);
        }
    }else{
        textLabel.width = kWeiboWidthList;
        
        long mode = [[NSUserDefaults standardUserDefaults] integerForKey:kPicMode];
        
        if (mode == SmallPicMode) {
            NSString *thumbnailImage = weiboModel.thumbnailImage;
            if (thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage]) {
                height += (80+10);
            }
        }else if (mode == LargePicMode){
            NSString *bmiddleImage = weiboModel.bmiddleImage;
            if (bmiddleImage != nil && ![@"" isEqualToString:bmiddleImage]) {
                height += (170+10);
            }
        }
        
    }
    
    NSString *weiboText = @"";
    NSString *nickName = weiboModel.user.screen_name;
    if (isRepost) {
        weiboText = [NSString stringWithFormat:@"@%@:%@",nickName, weiboModel.text];
    }else{
        weiboText = weiboModel.text;
    }
    
    textLabel.text = weiboText;
    height += textLabel.optimumSize.height;
    
    // weibo view height
    WeiboModel *relWeibo = weiboModel.relWeibo;
    if (relWeibo != nil) {
        //转发微博视图的高度
        float repostHeight = [WeiboView getWeiboViewHeight:relWeibo isRepost:YES isDetail:isDetail];
        height += (repostHeight);
    }
    
    if (isRepost) {
        height += 30;
    }
    
    return height;
}

+ (float)getFontSize:(BOOL)isDetail isRepost:(BOOL)isRepost{
    float fontSize = 14.0f;
    
    if (!isDetail) {
        if (!isRepost) {
            return LIST_FONT;
        }else{
            return LIST_REPOST_FONT;
        }
    }else{
        if (!isRepost) {
            return DETAIL_FONT;
        }else{
            return DETAIL_REPOST_FONT;
        }
    }
    
    return fontSize;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
        _parseText = [NSMutableString string];
    }
    return self;
}

- (void)_initView{
    _textLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    _textLabel.delegate = self;
    _textLabel.font = [UIFont systemFontOfSize:14.0f];
    _textLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"#4595CB" forKey:@"color"];
    _textLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self addSubview:_textLabel];
    
    _image = [[UIImageView alloc] initWithFrame:CGRectZero];
    _image.image = [UIImage imageNamed:@"page_image_loading.png"];
    _image.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_image];
    
    _repostBackgroundView = [UIFactory createImageView:@"timeline_retweet_background.png"];
    _repostBackgroundView.image = [_repostBackgroundView.image stretchableImageWithLeftCapWidth:25 topCapHeight:10];
    ((ThemeImageView *)_repostBackgroundView).leftCapWidth = 25;
    ((ThemeImageView *)_repostBackgroundView).topCapHeight = 10;
    _repostBackgroundView.backgroundColor = [UIColor clearColor];
    [self insertSubview:_repostBackgroundView atIndex:0];
    
}



//展示数据，设置布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self _renderTextLabel];
    
    [self _renderSourceWeibo];
    
    [self _renderImage];
    
    if (self.isRepost) {
        _repostBackgroundView.frame = self.bounds;
        _repostBackgroundView.hidden = NO;
    } else {
        _repostBackgroundView.hidden = YES;
    }
}

- (void)_renderTextLabel{
    float fontSize = [WeiboView getFontSize:self.isDetail isRepost:self.isRepost];
    _textLabel.font = [UIFont systemFontOfSize:fontSize];
    _textLabel.frame = CGRectMake(0, 0, self.width, 20);
    if (self.isRepost) {
        _textLabel.frame = CGRectMake(10, 10 , self.width-40, 0);
    }
    _textLabel.text = _parseText;
    
    CGSize textSize = _textLabel.optimumSize;
    _textLabel.height = textSize.height;
}

- (void)_renderSourceWeibo{
    WeiboModel *repostWeibo = _weiboModel.relWeibo;
    if (repostWeibo != nil) {
        _repostView.weiboModel = repostWeibo;
        float height = [WeiboView getWeiboViewHeight:repostWeibo isRepost:YES isDetail:self.isDetail];
        _repostView.frame = CGRectMake(0 , _textLabel.bottom, self.width, height);
        _repostView.backgroundColor = [UIColor clearColor];
        _repostView.hidden = NO;
    } else {
        _repostView.hidden = YES;
    }
}

- (void)_renderImage{
    if (self.isDetail) {
        NSString *bmiddleImage = _weiboModel.bmiddleImage;
        if (bmiddleImage != nil && ![@"" isEqualToString:bmiddleImage]) {
            _image.hidden = NO;
            _image.frame = CGRectMake(10, _textLabel.bottom + 10, 280, 200);
            
            [_image sd_setImageWithURL:[NSURL URLWithString:bmiddleImage]];
        }else{
            _image.hidden = YES;
        }
    } else {
        // pic mode
        long mode = [[NSUserDefaults standardUserDefaults] integerForKey:kPicMode];
        if (mode == SmallPicMode) {
            NSString *thumbnailImage = _weiboModel.thumbnailImage;
            if (thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage]) {
                _image.hidden = NO;
                _image.frame = CGRectMake(10, _textLabel.bottom + 10, 70, 80);
                
                [_image sd_setImageWithURL:[NSURL URLWithString:thumbnailImage]];
            }else{
                _image.hidden = YES;
            }
        }else if (mode == LargePicMode){
            NSString *bmiddleImage = _weiboModel.bmiddleImage;
            if (bmiddleImage != nil && ![@"" isEqualToString:bmiddleImage]) {
                _image.hidden = NO;
                _image.frame = CGRectMake(10, _textLabel.bottom + 10, 200, 160);
                
                [_image sd_setImageWithURL:[NSURL URLWithString:bmiddleImage]];

            }else{
                _image.hidden = YES;
            }
        }
    }

}

#pragma mark - RTLabel delegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url{
    
    NSString *absString = [url absoluteString];
    if ([absString hasPrefix:@"user"]) {
        NSString *urlString = [[url host] URLDecodedString];
        NSLog(@"%@", urlString);
        
        UserViewController *userVC = [[UserViewController alloc] init];
        id a = self.viewController;
        
        [self.viewController.navigationController pushViewController:userVC animated:YES];
        
    }else if ([absString hasPrefix:@""]){
        
        
    }else if ([absString hasPrefix:@""]){
    
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
