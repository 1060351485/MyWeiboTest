//
//  WeiboTableView.m
//  MyWbTest23
//
//  Created by Apple on 16/2/29.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "WeiboTableView.h"

@implementation WeiboTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        // change picture mode to small/large
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kReloadWeiboTableNotification object:nil];
        

    }
    return self;
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

- (void)tableView:(UITableView *)tableView didselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.eventDelegate respondsToSelector:@selector(tableView:selectRowAtIndexPath:)]) {
        [self.eventDelegate tableView:self selectRowAtIndexPath:indexPath];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.eventDelegate respondsToSelector:@selector(tableView:selectRowAtIndexPath:)]) {
        [self.eventDelegate tableView:self selectRowAtIndexPath:indexPath];
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  [WeiboView getWeiboViewHeight:[self.data objectAtIndex:indexPath.row] isRepost:NO isDetail:NO]+60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellid";
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    WeiboModel *weibo = [self.data objectAtIndex:indexPath.row];
    cell.weiboModel = weibo;
    cell.userInteractionEnabled = YES;
    //    [cell.contentView addSubview:weibo]
    return cell;
}

- (void)reloadData{
    [super reloadData];
    [self setLoadingIndicator:NO];
}

@end
