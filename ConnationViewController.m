//
//  ConnationViewController.m
//  Connotation
//
//  Created by LZXuan on 15-7-14.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "ConnationViewController.h"

#import "JHRefresh.h"
#import "CommentViewController.h"


#define kCellId @"ConnotationCell"
#define kScreenSize [UIScreen mainScreen].bounds.size

@implementation ConnationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //取消 透明 的导航条或者 tabBar 对 滚动视图的影响
    self.automaticallyAdjustsScrollViewInsets = NO;
    //初始化
    self.isRefreshing = NO;
    self.isLoadMore = NO;
    self.currentPage = 0;//开始第0页
    self.max_timestamp = @"-1";
    
    [self createTableView];
    [self createRequest];
    //下载第一页数据
    [self loadDataWithPage:self.currentPage count:30];
    //创建 刷新
    [self createRefreshView];
}

#pragma mark - 刷新
- (void)createRefreshView {
    //下拉刷新 给scrollView 增加的类别 增补的方法
    //arc 下 防止 两个强引用 导致 内存泄露
    //写一个弱引用指针 weakSelf 这样在block 中就不会 强引用
    __weak typeof(self)weakSelf = self;
    
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //只要下拉刷新就会 回调这个block
        if (weakSelf.isRefreshing) {
            //正在刷新 直接返回
            return ;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.currentPage = 0;
        weakSelf.max_timestamp = @"-1";
        //下拉 刷新  第 0 页 30条
        [weakSelf loadDataWithPage:weakSelf.currentPage count:30];
    }];
    
    //上拉加载
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //上拉 会 回调这个block
        if (weakSelf.isLoadMore) {
            return ;
        }
        weakSelf.isLoadMore = YES;
        weakSelf.currentPage++;//页码+1
        //上拉加载的时候max_timestamp 应该是最后一条数据的时间
        ConnotationModel *model = [weakSelf.dataArr lastObject];
        weakSelf.max_timestamp = model.update_time;
        //重新下载
        [weakSelf loadDataWithPage:weakSelf.currentPage count:15];
        
    }];
}
//结束刷新
- (void)endRefreshing {
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [self.tableView footerEndRefreshing];
    }
}



#pragma mark - 表格
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64-49) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ConnotationCell" bundle:nil] forCellReuseIdentifier:kCellId];
}
#pragma mark - 下载对象
- (void)createRequest {
    _manager = [AFHTTPRequestOperationManager manager];
    //设置 响应 格式 二进制 不解析
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //数据源数组
    self.dataArr = [[NSMutableArray alloc] init];
}
#pragma mark - 下载数据解析数据
- (void)loadDataWithPage:(NSInteger)page count:(NSInteger)count {
    NSString *url = [NSString stringWithFormat:kContentUrl,self.category,page,count,self.max_timestamp];
    //get请求下载
    //防止 两个强引用 导致死锁 内存泄露
    __weak typeof(self) weakSelf = self;
    
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下载成功");
        if (responseObject) {
            if (weakSelf.currentPage == 0 ) {
                //如果刷新的是第0页 那么要删除之前
                [weakSelf.dataArr removeAllObjects];
            }
            //解析数据 json
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *itemArr = dict[@"items"];
            //遍历数组
            for (NSDictionary*itemDict in itemArr) {
                //把字典的数据存放在 model 中
                ConnotationModel *model= [[ConnotationModel alloc] init];
                //kvc 进行赋值--》根据字典 依次对model 的属性赋值
                [model setValuesForKeysWithDictionary:itemDict];
                //等价于下面的 依次赋值
                /*
                model.wid = dict[@"wid"];
                model.wbody = dict[@"wbody"];
                 ....
                 */
                //存到数据源
                [weakSelf.dataArr addObject:model];
            }
            //数据源变了 那么要刷新
            [weakSelf.tableView reloadData];
            //下载完成了 要结束刷新
            [weakSelf endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
        [weakSelf endRefreshing];
    }];
    
}
#pragma mark - TableView协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConnotationCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    ConnotationModel *model = self.dataArr[indexPath.row];
    //填充
    //把 分类传给 cell
    cell.category = self.category;
    __weak typeof (self)weakSelf = self;
    [cell showDataWithModel:model jumpBlock:^{
        //实现 界面跳转
        CommentViewController *comment = [[CommentViewController alloc] init];
        [weakSelf.navigationController pushViewController:comment animated:YES];
    }];
    
    return cell;
}
//动态的计算 cell 的行高
//label 和 图片的高度 不一样
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConnotationModel *model = self.dataArr[indexPath.row];
    CGFloat h = 25;//第二个label y
    h += [LZXHelper textHeightFromTextString:model.wbody width:300 fontSize:14];
    if (model.wpic_middle.length) {
        //有图片
        // h/w = h1/w1--->h1 = h*w1/w
        h += model.wpic_m_height.doubleValue*300/model.wpic_m_width.doubleValue + 5;//有5像素间隔
    }
    h += 5 + 30 + 5;//第一个5 是button 和上面的间隔 第二个 5 是和cell 的下边界间隔
    return h;
}



@end







