//
//  WeiboModel.m
//  MyWbTest23
//
//  Created by Apple on 16/2/28.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "WeiboModel.h"

@implementation WeiboModel


- (NSDictionary *)attributeMapDictionary {
    NSDictionary *mapAtt = @{
                             @"createDate":@"created_at",
                             @"weiboId":@"id",
                             @"text":@"text",
                             @"source":@"source",
                             @"favorited":@"favorited",
                             @"thumbnailImage":@"thumbnail_pic",
                             @"bmiddleImage":@"bmiddle_pic",
                             @"originalImage":@"original_pic",
                             @"geo":@"geo",
                             @"repostsCount":@"reposts_count",
                             @"commentsCount":@"comments_count"
                             };
    
    return mapAtt;
}



- (void)setAttributes:(NSDictionary *)dataDic{
    [super setAttributes:dataDic];
    
    NSDictionary *retweetDic = [dataDic objectForKey:@"retweeted_status"];
    if (retweetDic != nil) {
        WeiboModel *relWeibo = [[WeiboModel alloc] initWithDataDic:retweetDic];
        self.relWeibo = relWeibo;
    }
    
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    if (userDic != nil) {
        UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
        self.user = user;
    }
    
}
@end
