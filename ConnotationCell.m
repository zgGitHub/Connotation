//
//  ConnotationCell.m
//  Connotation
//
//  Created by LZXuan on 15-7-15.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "ConnotationCell.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"

@implementation ConnotationCell

- (void)awakeFromNib {
    // Initialization code
    //选中 无风格
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//点赞
- (IBAction)likeClick:(UIButton *)sender {
    
    //判断是否被点过
    NSString *str = [self.category stringByAppendingString:self.model.wid];
    
    BOOL isLike = [[[NSUserDefaults standardUserDefaults] objectForKey:str]boolValue];
    if (isLike) {
        //被点过直接返回
        return;
    }
    
    //一旦点赞 要发 post 请求 提交给服务器
    /*
     // 点赞接口，post请求
     // fid为对应的wid，category同上
     #define kZanUrl @"http://223.6.252.214/weibofun/add_count.php?apiver=10500&vip=1&platform=iphone&appver=1.6&udid=6762BA9C-789C-417A-8DEA-B8D731EFDC0B"
     //请求体拼接参数是下面的形式参数
     // type=like&category=weibo_girls&fid=30310
 */
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //post
    //提交的参数
    NSDictionary *dict = @{
                @"type":@"like",
                @"category":self.category,
                @"fid":self.model.wid};
    
    [manager POST:kZanUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //服务器响应的数据
        NSDictionary *newDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dict:%@",newDict);
        if ([newDict[@"retcode"] integerValue] == 0) {
            NSLog(@"点赞成功");
            //本地保存 记录这个 数据 被点过赞
            //分类 和id 拼接 成一个唯一的字符串
            NSString *key = [self.category stringByAppendingString:self.model.wid];
            //本地存储
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //选中
            sender.selected = YES;
            //选中状态 标题 点赞数据+1
            [sender setTitle:[NSString stringWithFormat:@"赞:%ld",self.model.likes.integerValue+1] forState:UIControlStateSelected];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"post失败");
    }];
    
    
    
}
//评论
- (IBAction)commentClick:(UIButton *)sender {
    //委托 段子/趣图界面 进行界面跳转
    
    //调用block
    if (self.myBlock) {
        self.myBlock();
    }
}
- (void)showDataWithModel:(ConnotationModel *)model jumpBlock:(JumpBlock)block{
    //保存
    self.myBlock = block;
    //保存model
    self.model = model;
    //把一个秒转化为时间字符串
    self.dateLabel.text = [LZXHelper dateStringFromNumberTimer:model.update_time];
    self.bodyLabel.text = model.wbody;
    //重新计算bodyLabel高度
    CGRect frame = self.bodyLabel.frame;
    frame.size.height = [LZXHelper textHeightFromTextString:model.wbody width:320-20 fontSize:14];
    self.bodyLabel.frame = frame;
    
    CGRect imageFrame = self.wpicImageView.frame;
    if (model.wpic_middle.length) {
        //有图片的网络地址 那么表示有图片
        //根据图片的实际大小 和 显示 的宽等比例算出高
        //h/w = h1/w1--->h1 = h*w1/w
        
        imageFrame.size.height = model.wpic_m_height.doubleValue*300/model.wpic_m_width.doubleValue;
        //根据 self.bodyLabel.frame 算出 下面视图的y
        
        imageFrame.origin.y = CGRectGetMaxY(self.bodyLabel.frame)+5;
        //异步下载图片
        // 左边5像素 不拉伸 第6像素横向拉伸 其他像素不变
        // 距离顶部5像素 不拉伸 第6像素横向拉伸 其他像素不变
        UIImage *image = [[UIImage imageNamed: @"card_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        
        [self.wpicImageView sd_setImageWithURL:[NSURL URLWithString:model.wpic_middle] placeholderImage:image];
        
    }else {
        imageFrame.origin.y = CGRectGetMaxY(self.bodyLabel.frame);
        imageFrame.size.height = 0;
    }
    self.wpicImageView.frame = imageFrame;
    
    CGRect buttonFrame1 = self.likesButton.frame;
    CGRect buttonFrame2 = self.commentButton.frame;
    
    buttonFrame1.origin.y = CGRectGetMaxY(imageFrame)+5;
    buttonFrame2.origin.y = CGRectGetMaxY(imageFrame)+5;
    self.likesButton.frame = buttonFrame1;
    self.commentButton.frame = buttonFrame2;
    //给按钮标题
    
    [self.likesButton setTitle:[NSString stringWithFormat:@"赞:%ld",model.likes.integerValue] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithFormat:@"评论:%ld",model.comments.integerValue] forState:UIControlStateNormal];
    
    //判断是否被点过
    NSString *str = [self.category stringByAppendingString:self.model.wid];
    BOOL isLike = [[[NSUserDefaults standardUserDefaults] objectForKey:str]boolValue];
    [self.likesButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
    if (isLike) {
        self.likesButton.selected = YES;
    }else {
        self.likesButton.selected = NO;
    }
}


@end




