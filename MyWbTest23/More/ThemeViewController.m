//
//  ThemeViewController.m
//  MyWbTest23
//
//  Created by Apple on 16/2/26.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeManager.h"
#import "UIFactory.h"

@interface ThemeViewController ()

@end

@implementation ThemeViewController

#pragma mark - init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        ThemeManager *themeManager = [ThemeManager shareInstance];
        themes = [themeManager.themesPlist allKeys];
        self.title = @"主题切换";
    }
    return self;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [themes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        UILabel *label = [UIFactory createLabel:kThemeListLabel];
        label.frame = CGRectMake(10, 10, 200, 30);
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:16.0f];
        label.tag = 2013;
        [cell.contentView addSubview:label];
    }
//    cell.textLabel.text = themes[indexPath.row];
    UILabel *label = [[cell contentView] viewWithTag:2013];
    label.text = themes[indexPath.row];
    
    if ([label.text isEqualToString:@"defalut"]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else if ([label.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kThemeName]]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *theme = themes[indexPath.row];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:theme forKey:kThemeName];
    [ud synchronize];
    
    [tableView reloadData];
    
    ThemeManager *themeManager = [ThemeManager shareInstance];
    themeManager.curThemeName = theme;
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:false];
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:theme];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
