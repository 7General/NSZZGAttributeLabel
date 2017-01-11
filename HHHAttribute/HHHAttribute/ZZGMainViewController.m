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

#import "ZZGLabel.h"



#import "TTTAttributedLabel.h"


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
    
    // 2：创建富文本
    self.constString = @"今天和昨天,白日依山尽，黄河入海流。";
    
    NSAttributedString *attributedString  = [self.constString stringWithParagraphlineSpeace:3 textColor:[UIColor blueColor] textFont:[UIFont systemFontOfSize:15]];
    self.AttriLabel.attributeString = attributedString;
    
    NSRange  range = [self.constString rangeOfString:@"天" options:(NSCaseInsensitiveSearch)];
    [self.AttriLabel addLinkStringRange:range flag:@"day"];
    
    NSRange  range1 = [self.constString rangeOfString:@"昨" options:(NSCaseInsensitiveSearch)];
    [self.AttriLabel addLinkStringRange:range1 flag:@"yestarday"];
    
    NSRange  range2 = [self.constString rangeOfString:@"日依山尽" options:(NSCaseInsensitiveSearch)];
    [self.AttriLabel addLinkStringRange:range2 flag:@"flga2"];
    
    NSRange  range3 = [self.constString rangeOfString:@"明月光" options:(NSCaseInsensitiveSearch)];
    [self.AttriLabel addLinkStringRange:range3 flag:@"flga3"];
    
    [self.AttriLabel ApplayDraw];
    
    CGFloat height = [self.constString HeightParagraphSpeace:6 withFont:[UIFont systemFontOfSize:18] AndWidth:100];
    self.AttriLabel.frame = CGRectMake(100, 100, 100, height);
}

#pragma mark - 富文本点击事件
-(void)ZZGLabel:(ZZGAttributeLabel *)label didSelectWith:(NSString *)content {
    NSLog(@"--zzg---%@",content);
}





-(void)testTTTAttributedLabel {
    TTTAttributedLabel * label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.layer.borderWidth = 1;
    label.numberOfLines = 0;
    label.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:label];
    
    // 2：创建富文本
    self.constString = @"今天和昨天白日依山尽，黄河入海流";
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing              = 4.f;
    style.alignment                = NSTextAlignmentLeft;
}

-(void)initView {
    self.attributeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 200)];
    self.attributeLabel.numberOfLines = 0;
    [self.view addSubview:self.attributeLabel];
    self.constString = @"今天是中华人民共和国2017年1月10日，天气晴朗";
}

//1：创造一个富文本
// 2: 可任意添加关键字，并显示
// 3：渲染富文本
-(void)createAttributeString {
    
    // 设置段落
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    NSDictionary *attributes = @{ NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@.5f};
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:self.constString attributes:attributes];
    self.attributeStr = attrStr;
}
/**插入关键字*/
-(void)insterAttributeString:(NSString *)str {
    NSDictionary *keyFC = @{ NSKernAttributeName:@.5f,NSForegroundColorAttributeName:[UIColor greenColor]};
    NSRange  range = [self.constString rangeOfString:str options:(NSCaseInsensitiveSearch)];
    [self.attributeStr addAttributes:keyFC range:range];
}
/**开始渲染*/
-(void)resSender {
    self.attributeLabel.attributedText = self.attributeStr;
}
@end
