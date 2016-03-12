//
//  BaseTableView.h
//  MyWbTest23
//
//  Created by Apple on 16/2/29.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class BaseTableView;

@protocol UITableViewEventDelegate<NSObject>

@optional
- (void)pullDown:( BaseTableView * _Nonnull )tableView;
- (void)pullUp:( BaseTableView * _Nonnull )tableView;
- (void)tableView:( BaseTableView * _Nonnull )tableView selectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;

@end


@interface BaseTableView : UITableView<EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
}

@property (nonatomic) BOOL refreshHeader;
@property (nonatomic, strong) NSArray *_Nonnull data;
@property (nonatomic) id  <UITableViewEventDelegate> _Nonnull eventDelegate ;

@property (nonatomic, strong)  UIButton * _Nonnull moreButton;

@property (nonatomic) BOOL isMore;

- (void)doneLoadingTableViewData;
- (void)refreshData;
- (void)setLoadingIndicator:(BOOL)show;
@end
