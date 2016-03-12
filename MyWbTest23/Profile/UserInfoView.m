//
//  UserInfoView.m
//  MyWbTest23
//
//  Created by Apple on 16/3/11.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "UserInfoView.h"
#import "UIImageView+WebCache.h"

@implementation UserInfoView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *userInfoView = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoView" owner:self options:nil] lastObject];
        [self addSubview:userInfoView];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:self.user.avatar_large]];
    
    self.nameLabel.text = self.user.screen_name;
    NSString *gender = self.user.gender;
    NSString *genderName = @"未知";
    if ([gender isEqualToString:@"m"]) {
        genderName = @"男";
    }else{
        genderName = @"女";
    }
    if (!self.user.location) {
        self.user.location = @"";
    }
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@", genderName,self.user.location];
    self.infoLabel.text = self.user.description;
    
    self.countLabel.text = [NSString stringWithFormat:@"共%@条微博",[self.user.statuses_count stringValue]];
    
    long fans = [self.user.friends_count longValue];
    NSString *fanStr = [NSString stringWithFormat:@"%ld",fans];
    if (fans > 10000) {
        fanStr = [NSString stringWithFormat:@"%ld万",fans/10000];
    }
    self.fansBtn.title.text = @"粉丝";
    self.fansBtn.subtitle.text = fanStr;
    
    long flrs = [self.user.followers_count longValue];
    NSString *flrsStr = [NSString stringWithFormat:@"%ld",flrs];
//    if (flrs > 10000) {
//        flrsStr = [NSString stringWithFormat:@"%ld万",flrs/10000];
//    }
    self.attBtn.title.text = @"关注";
    self.attBtn.subtitle.text = flrsStr;
    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
