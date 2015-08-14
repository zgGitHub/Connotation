//
//  LZXModel.h
//  Connotation
//
//  Created by LZXuan on 15-7-15.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZXModel : NSObject
// 防止 使用kvc 赋值的时候 崩溃
//当使用kvc 赋值的时候 如果 找不到 相应地属性赋值 那么会调用这个方法 如果没有这个方法会崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end






