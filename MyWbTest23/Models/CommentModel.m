//
//  CommentModel.m
//  MyWbTest23
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (NSDictionary *)attributeMapDictionary {
    NSDictionary *mapAtt = @{
                             @"create_at":@"created_at",
                             @"id":@"id",
                             @"text":@"text",
                             @"source":@"source",
                             @"mid":@"mid",
                             @"idstr":@"idstr"
                             };
    
    return mapAtt;
}

- (void)setAttributes:(NSDictionary *)dataDic{
    [super setAttributes:dataDic];
    
    NSDictionary *weiboModel = [dataDic objectForKey:@"status"];
    if (weiboModel != nil) {
        WeiboModel *weibos = [[WeiboModel alloc] initWithDataDic:weiboModel];
        self.weibo = weibos;
    }
    
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    if (userDic != nil) {
        UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
        self.userModel = user;
    }
}

@end
