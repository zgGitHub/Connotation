//
//  ConnationViewController.h
//  Connotation
//
//  Created by LZXuan on 15-7-14.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "BaseViewController.h"
/*
 1.搭建框架
 2.MVC设计
 3.设计相应地model
 4.设计cell
 5.下载数据 解析数据 显示数据
 
 */

#import "AFNetworking.h"
#import "ConnotationCell.h"
#import "ConnotationModel.h"

@interface ConnationViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    //是否刷新
    BOOL _isRefreshing;
    BOOL _isLoadMore;
    NSInteger _currentPage;
    //下载任务管理
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic) BOOL isRefreshing;
@property (nonatomic) BOOL isLoadMore;
@property (nonatomic) NSInteger currentPage;

//记录刷新还是上拉加载 @"-1"表示第一页  @"其他时间"表示从这个时间开始加载数据
@property (nonatomic,copy) NSString *max_timestamp;


@end





