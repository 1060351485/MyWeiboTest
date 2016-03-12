//
//  CommentModel.h
//  MyWbTest23
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "WXBaseModel.h"
#import "UserModel.h"
#import "WeiboModel.h"

@interface CommentModel : WXBaseModel

@property (nonatomic, copy) NSString *create_at;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *idstr;
@property (nonatomic) NSNumber *id;
@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, strong) WeiboModel *weibo;
@end
