//
//  PicSizeViewController.m
//  MyWbTest23
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "PicSizeViewController.h"
#import "UIFactory.h"

@interface PicSizeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PicSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"图片尺寸";
        
    }
    return self;
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"PicSizeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        UILabel *label = [UIFactory createLabel:kThemeListLabel];
        label.frame = CGRectMake(10, 10, 200, 30);
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:16.0f];
        label.tag = 2015;
        [cell.contentView addSubview:label];
    }
    UILabel *label = [[cell contentView] viewWithTag:2015];
    
    long mode = [[NSUserDefaults standardUserDefaults] integerForKey:kPicMode];
    
    if (indexPath.row == 0) {
        label.text = @"小图";
    }else{
        label.text = @"大图";
    }
    
    if (indexPath.row == mode) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int mode = -1;
    if (indexPath.row == 0) {
        mode = SmallPicMode;
    }else if (indexPath.row == 1){
        mode = LargePicMode;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:kPicMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadWeiboTableNotification object:nil];

    [self.tableView reloadData];
    
    
    
//    [self.navigationController popViewControllerAnimated:YES];
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
