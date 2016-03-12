//
//  ThemeViewController.h
//  MyWbTest23
//
//  Created by Apple on 16/2/26.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "BaseViewController.h"

@interface ThemeViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>{

    NSArray *themes;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
