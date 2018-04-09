//
//  ZZGMainViewController.m
//  HHHAttribute
//
//  Created by 王会洲 on 17/1/10.
//  Copyright © 2017年 王会洲. All rights reserved.
//

#import "ZZGMainViewController.h"
#import "ZZGAttributeLabel.h"
#import "NSString+ZZGAttribute.h"





@interface ZZGMainViewController ()<ZZGAttributeLabelDelegate>

@property (nonatomic, strong) UILabel * attributeLabel;
/**全局变量富文本*/
@property (nonatomic, strong) NSMutableAttributedString * attributeStr;
/**全局Str*/
@property (nonatomic, strong) NSString * constString;

/**富文本标签*/
@property (nonatomic, strong) ZZGAttributeLabel * AttriLabel;

@end

@implementation ZZGMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAttribute];

}

/**创建富文本标签*/
-(void)initAttribute{
    self.AttriLabel = [ZZGAttributeLabel ZZGLabel];
    self.AttriLabel.layer.borderWidth = 1;
    self.AttriLabel.delegate = self;
    self.AttriLabel.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:self.AttriLabel];

    self.constString = @"今天和昨天,白日依山尽，黄河入海流。您好,很高兴为您服务,\n\r请问有什么可以帮您的\n服务费用问题\n贷款相关问题\n过户相关问题\n\r买车相关问题\n可以直接向小瓜提问";
    
    NSAttributedString *attributedString  = [self.constString stringWithParagraphlineSpeace:3 textColor:[UIColor blueColor] textFont:[UIFont systemFontOfSize:15]];
    self.AttriLabel.attributeString = attributedString;
    
    NSRange  range = [self.constString rangeOfString:@"服务费用问题" options:(NSCaseInsensitiveSearch)];
    [self.AttriLabel addLinkStringRange:range flag:@"day"];
    
    NSRange  range1 = [self.constString rangeOfString:@"过户相关问题" options:(NSCaseInsensitiveSearch)];
    [self.AttriLabel addLinkStringRange:range1 flag:@"yestarday"];
    
    NSRange  range2 = [self.constString rangeOfString:@"买车相关问题" options:(NSCaseInsensitiveSearch)];
    [self.AttriLabel addLinkStringRange:range2 flag:@"flga2"];

    [self.AttriLabel ApplayDraw];
    CGFloat height = [self.constString HeightParagraphSpeace:6 withFont:[UIFont systemFontOfSize:18] AndWidth:100];
    self.AttriLabel.frame = CGRectMake(100, 100, 100, height);
}

#pragma mark - 富文本点击事件
-(void)ZZGLabel:(ZZGAttributeLabel *)label didSelectWith:(NSString *)content {
    NSLog(@"--zzg---%@",content);
}



@end
