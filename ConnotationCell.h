//
//  ConnotationCell.h
//  Connotation
//
//  Created by LZXuan on 15-7-15.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnotationModel.h"

typedef void (^JumpBlock)(void);

@interface ConnotationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wpicImageView;
@property (weak, nonatomic) IBOutlet UIButton *likesButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

//保存model
@property (nonatomic,strong) ConnotationModel *model;
//分类
@property (nonatomic,copy) NSString *category;
//保存block
@property (nonatomic,copy) JumpBlock myBlock;

//点赞
- (IBAction)likeClick:(UIButton *)sender;
//评论
- (IBAction)commentClick:(UIButton *)sender;
//填充cell
- (void)showDataWithModel:(ConnotationModel *)model jumpBlock:(JumpBlock)block;


@end









