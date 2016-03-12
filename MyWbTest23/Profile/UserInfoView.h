//
//  UserInfoView.h
//  MyWbTest23
//
//  Created by Apple on 16/3/11.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "RectButton.h"

@interface UserInfoView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet RectButton *attBtn;
@property (weak, nonatomic) IBOutlet RectButton *fansBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@property (nonatomic, strong) UserModel *user;

- (instancetype)initWithFrame:(CGRect)frame;

@end
