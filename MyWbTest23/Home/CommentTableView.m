//
//  CommentTableView.m
//  MyWbTest23
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentViewCell.h"

@implementation CommentTableView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
    }
    return self;
}


- (void)awakeFromNib{
    [super awakeFromNib];
}


#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40+[CommentViewCell getCommentHeight:[self.data objectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"commentCell";
    CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CommentViewCell" owner:self options:nil];
        cell = [array lastObject];
    }
    
    CommentModel *commentModel = [self.data objectAtIndex:indexPath.row];
    cell.commentModel = commentModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *commentBar =[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
    commentBar.backgroundColor = [UIColor whiteColor];
    
    UILabel *commentCount = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 15)];
    commentCount.backgroundColor = [UIColor clearColor];
    commentCount.font = [UIFont boldSystemFontOfSize:14.0f];
    commentCount.textColor = [UIColor blueColor];
    
    NSNumber *num = [self.commentDict objectForKey:@"total_number"];
    if (num == NULL) {
        num = [NSNumber numberWithInt:0];
    }
    commentCount.text = [NSString stringWithFormat:@"评论:%@",num];
    [commentBar addSubview:commentCount];
    
    UIImageView *seperatebar = [[UIImageView alloc] initWithFrame:CGRectMake(0, commentBar.bottom-1, tableView.width, 1)];
    seperatebar.image = [UIImage imageNamed:@"userinfo_header_separator"];
    [commentBar addSubview:seperatebar];
    
    return commentBar;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    return indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.0f;
//}

@end
