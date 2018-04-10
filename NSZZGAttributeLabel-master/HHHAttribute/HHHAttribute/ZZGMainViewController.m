//
//  NSMainViewController.m
//  HHHAttribute
//
//  Created by 王会洲 on 17/1/10.
//  Copyright © 2017年 王会洲. All rights reserved.
//

#import "ZZGMainViewController.h"

#import "NSAttributedLabel.h"





@interface NSMainViewController ()<NSAttributedLabelDelegate>

@property (nonatomic, strong) UILabel * attributeLabel;
/**全局变量富文本*/
@property (nonatomic, strong) NSMutableAttributedString * attributeStr;
/**全局Str*/
@property (nonatomic, strong) NSString * constString;

/**富文本标签*/
//@property (nonatomic, strong) NSAttributeLabel * AttriLabel;




@property(nonatomic , strong) NSAttributedLabel * ttLabel;


@end

@implementation NSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initAttribute];
    
    [self NS];
//    [self settest];
}

- (void)settest {
    NSAttributedLabel *label = [[NSAttributedLabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor lightGrayColor];
//    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    
    NSString *text = @"Lorem ipsum dolar sit amet";
    [label setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange boldRange = [[mutableAttributedString string] rangeOfString:@"ipsum dolar" options:NSCaseInsensitiveSearch];
        NSRange strikeRange = [[mutableAttributedString string] rangeOfString:@"sit amet" options:NSCaseInsensitiveSearch];
        NSLog(@"----------------");
        // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
        UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:14];
        CTFontRef font = CTFontCreateWithName((CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        if (font) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)[UIFont systemFontOfSize:14] range:boldRange];
            [mutableAttributedString addAttribute:@"TTTCustomStrikeOut" value:[NSNumber numberWithBool:YES] range:strikeRange];
            // (NSString*)kCTForegroundColorAttributeName : (id)[[UIColor greenColor] CGColor],
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[UIColor greenColor] range:strikeRange];
            CFRelease(font);
        }
        
        return mutableAttributedString;
    }];
    
    [self.view addSubview:label];
}






- (void)NS {
    //添加文本信息
    NSAttributedLabel *butedText = [[NSAttributedLabel alloc]
                                      initWithFrame:CGRectMake(0,100,300,389)];
    
    butedText.backgroundColor = [UIColor lightGrayColor];
    butedText.delegate = self;
    butedText.lineHeightMultiple = 2;
    UIFont *font = [UIFont systemFontOfSize:20];
    butedText.font = font;
    butedText.numberOfLines = 0;
    butedText.lineBreakMode = NSLineBreakByWordWrapping;
//    NSString *text = [NSString stringWithFormat:@"今天和昨天,白日依山尽，黄河入海流。您好,很高兴为您服务,请问有什么可以帮您的\n服务费用问题\n贷款相关问题\n过户相关问题\n买车相关问题\n可以直接向小瓜提问"];
    NSString *text = [NSString stringWithFormat:@"服务费用问题\n贷款相关问题\n过户相关问题\n\n买车相关问题\n"];

    
    [butedText setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        CGFloat height =  [NSAttributedLabel sizeThatFitsAttributedString:mutableAttributedString withConstraints:CGSizeMake(300, MAXFLOAT) limitedToNumberOfLines:0].height;
        NSLog(@"-------%f",height);
        return mutableAttributedString;
    }];
    
    //创建设置数组
//    CGFloat lineHeightMultiple = 2.0;
//    CTParagraphStyleSetting lineSpaceStyle;
//    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
//    lineSpaceStyle.valueSize = sizeof(lineHeightMultiple);
//    lineSpaceStyle.value =&lineHeightMultiple;
//    CTParagraphStyleSetting settings[ ] ={lineSpaceStyle};
//    CTParagraphStyleRef style = CTParagraphStyleCreate(settings , sizeof(settings));
    
    butedText.linkAttributes = @{
                                  //(NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:YES],
                                  (NSString*)kCTForegroundColorAttributeName : (id)[[UIColor greenColor] CGColor],
                                  (NSString*)kCTFontAttributeName : (id)[UIFont systemFontOfSize:20],
//                                  (NSString *)kCTParagraphStyleAttributeName:(id)style
                                  };
    
    butedText.verticalAlignment = NSAttributedLabelVerticalAlignmentTop;
    
    NSDictionary * keyWords = @{@"贷款相关问题":@"daikuan",@"服务费用问题":@"fuwu",@"过户相关问题":@"guohu"};
    
    for (NSString * item in keyWords.allKeys) {
        NSRange range = [text rangeOfString:item options:NSCaseInsensitiveSearch];
        [butedText addLinkToURL:[NSURL URLWithString:keyWords[item]] withRange:range];
    }
    [self.view addSubview:butedText];
    
  
}


- (void)attributedLabel:(NSAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"%@",url);
}
-(void)attributedLabel:(NSAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents {
    NSLog(@"---%@",addressComponents);
}

/**创建富文本标签*/
-(void)initAttribute{
//    self.AttriLabel = [NSAttributeLabel NSLabel];
//    self.AttriLabel.layer.borderWidth = 1;
//    self.AttriLabel.delegate = self;
//    self.AttriLabel.layer.borderColor = [UIColor redColor].CGColor;
//    [self.view addSubview:self.AttriLabel];
//
//    self.constString = @"今天和昨天,白日依山尽，黄河入海流。您好,很高兴为您服务,\n请问有什么可以帮您的\n服务费用问题\n贷款相关问题\n过户相关问题\n买车相关问题\n可以直接向小瓜提问";
//
//    NSAttributedString *attributedString  = [self.constString stringWithParagraphlineSpeace:3 textColor:[UIColor blueColor] textFont:[UIFont systemFontOfSize:15]];
//    self.AttriLabel.attributeString = attributedString;
//
//    NSRange  range = [self.constString rangeOfString:@"服务费用问题" options:(NSCaseInsensitiveSearch)];
//    [self.AttriLabel addLinkStringRange:range flag:@"fuwufeiyong"];
//
//    NSRange  range1 = [self.constString rangeOfString:@"贷款相关问题" options:(NSCaseInsensitiveSearch)];
//    [self.AttriLabel addLinkStringRange:range1 flag:@"daikuan"];
//
//    NSRange  range2 = [self.constString rangeOfString:@"过户相关问题" options:(NSCaseInsensitiveSearch)];
//    [self.AttriLabel addLinkStringRange:range2 flag:@"guohu"];
//
//    [self.AttriLabel ApplayDraw];
//    CGFloat height = [self.constString HeightParagraphSpeace:6 withFont:[UIFont systemFontOfSize:18] AndWidth:200];
//    self.AttriLabel.frame = CGRectMake(100, 100, 200, height);
}

#pragma mark - 富文本点击事件
//-(void)NSLabel:(NSAttributeLabel *)label didSelectWith:(NSString *)content {
//    NSLog(@"--NS---%@",content);
//}



@end
