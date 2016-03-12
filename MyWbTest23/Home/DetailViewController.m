//
//  DetailViewController.m
//  MyWbTest23
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "WBHttpRequest.h"
#import <JSONKit.h>
#import "CommentModel.h"

@interface DetailViewController () <WBHttpRequestDelegate, UITableViewEventDelegate>

@property (weak, nonatomic) IBOutlet CommentTableView *commentTableView;

@end

@implementation DetailViewController



#pragma mark - init

- (void)_initView{
    self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.view.autoresizesSubviews = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    NSURL *url = [NSURL URLWithString:_weiboModel.user.profile_image_url];
    
    self.userImageView.layer.cornerRadius = 5;
    self.userImageView.layer.masksToBounds = YES;
    [self.userImageView sd_setImageWithURL:url];
    
    self.userLabel.text = _weiboModel.user.screen_name;
    
    [tableHeaderView addSubview:self.userBarView];
    tableHeaderView.height += 60;
    
//    NSLog(@"tableHeaderView bottom:%f",tableHeaderView.bottom);
//    NSLog(@"tableFooterView top:%f",_commentTableView.tableFooterView.bounds.origin.y);

    float h = [WeiboView getWeiboViewHeight:self.weiboModel isRepost:NO isDetail:YES];
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectMake(10, _userBarView.bottom+10, ScreenWidth-20, h)];
    _weiboView.isDetail = YES;
    _weiboView.weiboModel = _weiboModel;
    
    [tableHeaderView addSubview:_weiboView];
    tableHeaderView.height += h + 10;
    
    _commentTableView.refreshHeader = YES;
    _commentTableView.eventDelegate = self;
    _commentTableView.dataSource = _commentTableView;
    _commentTableView.delegate = _commentTableView;
    _commentTableView.tableHeaderView = tableHeaderView;
}

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self _initView];
    [self loadData];
}


- (void)viewDidAppear:(BOOL)animated{
    self.view.height = 603;
    _commentTableView.height = 603;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib{
    [super awakeFromNib];
}


#pragma mark - data

- (void)loadData{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [[ud objectForKey:@"AuthData"] objectForKey:@"AccessToken"];
    NSString *url = @"https://api.weibo.com/2/comments/show.json";
    NSString *weiboId = [_weiboModel.weiboId stringValue];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:weiboId,@"id",@"20",@"count",nil];
    
    [WBHttpRequest requestWithAccessToken:token url:url httpMethod:@"GET" params:params delegate:self withTag:@"loadComments"];
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
    
    if ([request.tag isEqualToString:@"loadComments"]) {
        
        NSDictionary *dict = [result objectFromJSONStringWithParseOptions:JKParseOptionStrict];
        NSDictionary *comment = [dict objectForKey:@"comments"];
        NSMutableArray *comments = [NSMutableArray arrayWithCapacity:[comment count]];
        
        for (NSDictionary *dict in comment) {
            CommentModel *commentModel = [[CommentModel alloc] initWithDataDic:dict];
            [comments addObject:commentModel];
        }
        
        self.lastCommentId = [((CommentModel *)[comments lastObject]).id stringValue];
        self.commentTableView.commentDict = dict;
        self.commentData = comments;
        self.commentTableView.data = comments;
        
        [self.commentTableView reloadData];

        if([comments count] >= 20){
            self.commentTableView.isMore = YES;
        }else{
            self.commentTableView.isMore = NO;
        }
        [_commentTableView setLoadingIndicator:NO];
        
    } else if ([request.tag isEqualToString:@"pullUpComment"]){
        
        [self pullUpDataFinish:result];
    } else if ([request.tag isEqualToString:@"pullDownComment"]){
        [self pullDownDataFinish:result];
    }
}

#pragma mark - event delegate

- (void)pullDown:( BaseTableView * _Nonnull )tableView{
    [self pullDownData];
}
- (void)pullUp:( BaseTableView * _Nonnull )tableView{
    [self pullUpData];
}
- (void)tableView:( BaseTableView * _Nonnull )tableView selectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath{
    
}

- (void)pullDownData{
    if (self.lastCommentId.length == 0) {
        NSLog(@"last评论id为空");
        return;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [[ud objectForKey:@"AuthData"] objectForKey:@"AccessToken"];
    NSString *url = @"https://api.weibo.com/2/comments/show.json";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self.weiboModel.weiboId stringValue],@"id",@"20",@"count",self.lastCommentId,@"max_id",nil];
    [WBHttpRequest requestWithAccessToken:token
                                      url:url
                               httpMethod:@"GET"
                                   params:params
                                 delegate:self
                                  withTag:@"pullDownComment"];
}

- (void)pullDownDataFinish:(NSString *)result{
    
    NSDictionary *dict = [result objectFromJSONStringWithParseOptions:JKParseOptionStrict
                                                                error:nil];
    NSArray *commentsArray = [dict objectForKey:@"comments"];
    
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:[commentsArray count]];
    
    for (NSDictionary *commentDict in commentsArray) {
        CommentModel *commentModel = [[CommentModel alloc] initWithDataDic:commentDict];
        [comments addObject:commentModel];
    }
    if ([comments firstObject]) {
        [comments removeObjectAtIndex:0];
    }
    if (comments.count > 0) {
        CommentModel *lastComment = (CommentModel *)[comments lastObject];
        self.lastCommentId = [lastComment.id stringValue];
    }

    [self.commentData addObjectsFromArray:comments];
    _commentTableView.data = self.commentData;
    
    if (comments.count >= 19) {
        _commentTableView.isMore = YES;
    }else{
        _commentTableView.isMore = NO;
    }
    
    [_commentTableView reloadData];
    [_commentTableView doneLoadingTableViewData];
    
}

- (void)pullUpData{
    
    if (self.lastCommentId.length == 0) {
        NSLog(@"last评论id为空");
        return;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [[ud objectForKey:@"AuthData"] objectForKey:@"AccessToken"];
    NSString *url = @"https://api.weibo.com/2/comments/show.json";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self.weiboModel.weiboId stringValue],@"id",self.lastCommentId,@"max_id",@"20",@"count",nil];
    [WBHttpRequest requestWithAccessToken:token
                                      url:url
                               httpMethod:@"GET"
                                   params:params
                                 delegate:self
                                  withTag:@"pullUpComment"];
}

- (void)pullUpDataFinish:(NSString *)result{
    NSDictionary *dict = [result objectFromJSONStringWithParseOptions:JKParseOptionStrict
                                                                error:nil];
    NSArray *commentsArray = [dict objectForKey:@"comments"];
    
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:[commentsArray count]];
    
    for (NSDictionary *commentDict in commentsArray) {
        CommentModel *commentModel = [[CommentModel alloc] initWithDataDic:commentDict];
        [comments addObject:commentModel];
    }
    if ([comments firstObject]) {
        [comments removeObjectAtIndex:0];
    }
    if (comments.count > 0) {
        CommentModel *lastComment = (CommentModel *)[comments lastObject];
        self.lastCommentId = [lastComment.id stringValue];
    }
    
    [self.commentData addObjectsFromArray:comments];
    _commentTableView.data = self.commentData;

    if (comments.count >= 19) {
        _commentTableView.isMore = YES;
    }else{
        _commentTableView.isMore = NO;
    }
    
    [_commentTableView reloadData];
    [_commentTableView setLoadingIndicator:NO];
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
