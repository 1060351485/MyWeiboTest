//
//  CommentViewCell.h
//  MyWbTest23
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "CommentModel.h"

@interface CommentViewCell : UITableViewCell<RTLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *commentTime;
@property (nonatomic, strong) RTLabel *comment;
@property (nonatomic, strong) CommentModel *commentModel;

+ (float)getCommentHeight:(CommentModel *)commentModel;

@end
