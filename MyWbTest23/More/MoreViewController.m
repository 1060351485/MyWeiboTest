//
//  MoreViewController.m
//  MyWbTest23
//
//  Created by Apple on 16/2/23.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "MoreViewController.h"
#import "ThemeViewController.h"
#import "PicSizeViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:  nibBundleOrNil];
    self.title = @"More";
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"主题";
    } else {
        cell.textLabel.text = @"图片尺寸";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if (indexPath.row == 0) {
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        [self.navigationController pushViewController:themeVC animated:true];
    } else {
        PicSizeViewController *picVC = [[PicSizeViewController alloc] init];
        [self.navigationController pushViewController:picVC animated:true];
    }
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:false];

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
