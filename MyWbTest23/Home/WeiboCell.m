//
//  WeiboCell.m
//  MyWbTest23
//
//  Created by Apple on 16/2/28.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "WeiboCell.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "UIUtils.h"
#import "RegexKitLite.h"

@implementation WeiboCell

#pragma mark - init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)_initView{
    _userImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _userImage.backgroundColor = [UIColor clearColor];
    _userImage.layer.cornerRadius = 5;
    _userImage.layer.borderWidth = 0.5;
    _userImage.layer.borderColor = [UIColor grayColor].CGColor;
    _userImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_userImage];
    
    //昵称
    _nickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nickLabel.backgroundColor = [UIColor clearColor];
    _nickLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:_nickLabel];
    
    _repostCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _repostCountLabel.font = [UIFont systemFontOfSize:12.0f];
    _repostCountLabel.backgroundColor = [UIColor clearColor];
    _repostCountLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_repostCountLabel];
    
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentLabel.font = [UIFont systemFontOfSize:12.0f];
    _commentLabel.backgroundColor = [UIColor clearColor];
    _commentLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_commentLabel];
    
    _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _sourceLabel.font = [UIFont systemFontOfSize:12.0f];
    _sourceLabel.backgroundColor = [UIColor clearColor];
    _sourceLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_sourceLabel];
    
    _createLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _createLabel.font = [UIFont systemFontOfSize:12.0f];
    _createLabel.backgroundColor = [UIColor clearColor];
    _createLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:_createLabel];
    
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_weiboView];
    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"statusdetail_cell_sepatator.png"]];
    self.contentView.userInteractionEnabled = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _userImage.frame = CGRectMake(5, 5, 35, 35);
    NSString *userImageUrl = _weiboModel.user.profile_image_url;
    [_userImage sd_setImageWithURL:[NSURL URLWithString:userImageUrl]];
    
    _nickLabel.frame = CGRectMake(50, 5, 200, 20);
    _nickLabel.text = _weiboModel.user.screen_name;
    
    NSString *createDate = _weiboModel.createDate;
    if (createDate != nil) {
        NSDate *date = [UIUtils dateFromFomate:createDate formate:@"E M d HH:mm:ss Z yyyy"];
        NSString *dateString = [UIUtils stringFromFomate:date formate:@"MM-dd HH:mm"];
        _createLabel.text = dateString;
        _createLabel.frame = CGRectMake(50, self.height-20, 100, 20);
        [_createLabel sizeToFit];
        _createLabel.hidden = NO;
    }else{
        _createLabel.hidden = YES;
    }
    
    NSString *source = _weiboModel.source;
    NSString *ret = [self parseSource:source];
    if (ret != nil) {
        _sourceLabel.hidden = NO;
        _sourceLabel.text = [NSString stringWithFormat:@"来自%@",ret];
        _sourceLabel.frame = CGRectMake(_createLabel.right+8, _createLabel.top, 100, 20);
        [_sourceLabel sizeToFit];
    }else{
        _sourceLabel.hidden = YES;
    }
    
    _weiboView.weiboModel = _weiboModel;
    
    float h = [WeiboView getWeiboViewHeight:_weiboModel isRepost:NO isDetail:NO];
    _weiboView.frame = CGRectMake(50, _nickLabel.bottom+10, kWeiboWidthList, h);
    
    [_weiboView setNeedsLayout];
}

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - action

- (NSString *)parseSource:(NSString *)source{
    NSString *regrex = @">\\w+<";
    NSArray *matchArray = [source componentsMatchedByRegex:regrex];
    if ([matchArray count] > 0) {
        NSString *ret = [matchArray objectAtIndex:0];
        NSRange range;
        range.location = 1;
        range.length = ret.length-2;
        return [ret substringWithRange:range];
    }
    return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
}

@end
