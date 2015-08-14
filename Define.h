//
//  Define.h
//  Connotation
//
//  Created by LZXuan on 15-7-14.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#ifndef Connotation_Define_h
#define Connotation_Define_h

#import "LZXHelper.h"


// category对应的字符串为:
#define kJokes @"weibo_jokes"  // 段子
#define kPics @"weibo_pics"    // 趣图
#define kVideos @"weibo_videos"// 视频
#define kGirls @"weibo_girls"  // 美女

// 段子 趣图 视频 美女 接口
#define kContentUrl @"http://223.6.252.214/weibofun/weibo_list.php?apiver=10500&category=%@&page=%ld&page_size=%ld&max_timestamp=%@"
// 页面从第0页开始30条开始，然后是第1页15条，第2页15条...
// max_timestamp 第0页，或者下拉刷新，值为-1，否则，为最后一个条目的update_time字段的值!(特别注意)
//-1 用于下拉刷新  page == 0 下拉刷新 最多刷新30条
//上拉加载 的时候max_timestamp应该是 数据源中最后一条数据的时间
//默认加载15条

// 评论接口
// fid为对应的wid，category同上
#define kCommentUrl @"http://223.6.252.214/weibofun/comments_list.php?apiver=10600&fid=%@&&category=%@&page=0&page_size=15&max_timestamp=-1"

// 点赞接口，post请求
// fid为对应的wid，category同上
#define kZanUrl @"http://223.6.252.214/weibofun/add_count.php?apiver=10500&vip=1&platform=iphone&appver=1.6&udid=6762BA9C-789C-417A-8DEA-B8D731EFDC0B"
//请求体拼接参数是下面的形式参数
// type=like&category=weibo_girls&fid=30310


#endif
