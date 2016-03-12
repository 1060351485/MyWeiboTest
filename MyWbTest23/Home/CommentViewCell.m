//
//  CommentViewCell.m
//  MyWbTest23
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "CommentViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"
#import "NSString+URLEncoding.h"

@implementation CommentViewCell

#pragma mark - init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [self _initView];
    [self layoutSubviews];
}

- (void)_initView{
    _userImage = (UIImageView *)[self viewWithTag:200];
    _userName = (UILabel *)[self viewWithTag:201];
    _commentTime = (UILabel *)[self viewWithTag:202];
    _comment = [[RTLabel alloc] initWithFrame:CGRectMake(_userImage.right+10, _userName.bottom+5, 240, 21)];
    _comment.font = [UIFont systemFontOfSize:14.0f];
    _comment.delegate = self;
    
    _comment.linkAttributes = [NSDictionary dictionaryWithObject:@"#4595CB" forKey:@"color"];
    _comment.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    
    [self.contentView addSubview:_comment];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSString *userUrl = _commentModel.userModel.profile_image_url;
    [_userImage sd_setImageWithURL:[NSURL URLWithString:userUrl]];
    
    _userName.text = self.commentModel.userModel.screen_name;
    _commentTime.text = [UIUtils fomateString:self.commentModel.create_at];
    _commentTime.font = [UIFont systemFontOfSize:14.0f];
    if (self.commentModel.text.length != 0) {
        _comment.text = [UIUtils parseLink:self.commentModel.text];
    }else{
        _comment.text = @"";
    }
    _comment.height = _comment.optimumSize.height;
    
}

#pragma mark - rtlabel delegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url{
    NSString *urlString = [url host];
    NSLog(@"%@",[urlString URLDecodedString]);
}

#pragma mark - action

+ (float)getCommentHeight:(CommentModel *)commentModel{
    RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, 240, 0)];
    label.text = commentModel.text;
    label.font = [UIFont systemFontOfSize:14.0f];
    return label.optimumSize.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
