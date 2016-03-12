//
//  DetailViewController.h
//  MyWbTest23
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "CommentTableView.h"
#import "CommentModel.h"

@interface DetailViewController : BaseViewController{

    WeiboView *_weiboView;

}

@property (nonatomic, strong) WeiboModel *weiboModel;

@property (strong, nonatomic) IBOutlet UIView *userBarView;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@property (nonatomic, strong) NSString *lastCommentId;

@property (nonatomic, strong) NSMutableArray *commentData;

@end
