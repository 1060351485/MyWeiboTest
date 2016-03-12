//
//  BaseTableView.m
//  MyWbTest23
//
//  Created by Apple on 16/2/29.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

- (void)setRefreshHeader:(BOOL)refreshHeader{
    _refreshHeader = refreshHeader;
    if (_refreshHeader) {
        [self addSubview:_refreshHeaderView];
    }else{
        if ([_refreshHeaderView superview]) {
            [_refreshHeaderView removeFromSuperview];
        }
    }
}

#pragma mark - init

- (void)awakeFromNib{
    [self _initView];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)_initView{
    
    self.delegate = self;
    self.dataSource = self;

    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f-self.bounds.size.height, self.width, self.bounds.size.height)];
    _refreshHeaderView.backgroundColor = [UIColor clearColor];
    _refreshHeaderView.delegate = self;

    _refreshHeader = YES;
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton.backgroundColor = [UIColor blueColor];
    _moreButton.frame = CGRectMake(0, 0, ScreenWidth, 40);
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_moreButton setTitle:@"上拉加载更多" forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.tag = 235;
    [indicator stopAnimating];
    indicator.frame = CGRectMake(100, 10, 20, 20);
    [_moreButton addSubview:indicator];
    
    self.isMore = YES;
    self.tableFooterView = _moreButton;
}

- (void)refreshData{
    [_refreshHeaderView refreshLoading:self];
}

- (void)loadMoreAction{
    NSLog(@"loadMoreClick！！！");
    if ([self.eventDelegate respondsToSelector:@selector(pullUp:)]) {
        [self setLoadingIndicator:YES];
        [self.eventDelegate pullUp:self];
    }
}

- (void)setLoadingIndicator:(BOOL)show{
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[_moreButton viewWithTag:235];
    if (show) {
        [indicator startAnimating];
        _moreButton.hidden = NO;
        _moreButton.enabled = NO;
        [_moreButton setTitle:@"正在加载......" forState:UIControlStateNormal];
    }else{
        if ([self.data count] > 0) {
            _moreButton.hidden = NO;
            [indicator stopAnimating];
            _moreButton.enabled = YES;
            [_moreButton setTitle:@"上拉加载" forState:UIControlStateNormal];

            NSLog(@"moreButton frame: top=%f,bottom=%f,width=%f,height=%f", _moreButton.top, _moreButton.bottom,_moreButton.frame.size.width,_moreButton.height);
            NSLog(@"tableview frame: top=%f,bottom=%f,width=%f,height=%f", [_moreButton superview].top, [_moreButton superview].bottom,[_moreButton superview].frame.size.width,[_moreButton superview].height);
            
            if (!self.isMore) {
                [_moreButton setTitle:@"加载完成" forState:UIControlStateNormal];
                _moreButton.enabled = NO;
            }
        }else{
            _moreButton.hidden = YES;
        }
        
    }
}

#pragma mark - ego delegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    [self reloadTableViewDataSource];
    
    if ([self.eventDelegate respondsToSelector:@selector(pullDown:)]) {
        [self.eventDelegate pullDown:self];
    }
    
//    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    
    return _reloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view{
    return [NSDate date];
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark - tableView scorllView delegate

- (void)reloadTableViewDataSource{
    _reloading = YES;
}

- (void)doneLoadingTableViewData{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.eventDelegate respondsToSelector:@selector(tableView:selectRowAtIndexPath:)]) {
        [self.eventDelegate tableView:self selectRowAtIndexPath:indexPath];
    }
}


@end
