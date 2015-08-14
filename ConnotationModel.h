//
//  ConnotationModel.h
//  Connotation
//
//  Created by LZXuan on 15-7-15.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "LZXModel.h"
//数据模型  一个cell  对应 一个数据模型对象



@interface ConnotationModel : LZXModel
@property (nonatomic, copy) NSString *wid;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *wbody;
@property (nonatomic, copy) NSString *comments;
@property (nonatomic, copy) NSString *likes;
@property (nonatomic, copy) NSString *wpic_m_width;
@property (nonatomic, copy) NSString *wpic_m_height;
@property (nonatomic, copy) NSString *wpic_middle;
@property (nonatomic, copy) NSString *wpic_large;
@end

/*
 {
 "wid": "65886",
 "update_time": "1436924700",
 "wbody": "你信不信？",
 "comments": "7",
 "likes": "274.56",
 "wpic_s_width": "120",
 "wpic_s_height": "94",
 "wpic_m_width": "440",
 "wpic_m_height": "346",
 "is_gif": "0",
 "wpic_small": "http://ww4.sinaimg.cn/thumbnail/e55451afjw1eu2ro9rq38j20cs0a2mz1.jpg",
 "wpic_middle": "http://ww4.sinaimg.cn/bmiddle/e55451afjw1eu2ro9rq38j20cs0a2mz1.jpg",
 "wpic_large": "http://ww4.sinaimg.cn/large/e55451afjw1eu2ro9rq38j20cs0a2mz1.jpg"
 },
 
 */







