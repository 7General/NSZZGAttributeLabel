//
//  NSString+ZZGAttribute.h
//  HHHAttribute
//
//  Created by 王会洲 on 17/1/10.
//  Copyright © 2017年 王会洲. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (ZZGAttribute)


// 用于搜寻一段字符串在另外一段字符串中的NSRange值
- (NSRange)rangeFrom:(NSString *)string;

// 本字符串的range
- (NSRange)range;

/**获取行高*/
-(CGFloat)HeightParagraphSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font AndWidth:(CGFloat)width;

-(NSAttributedString *)stringWithParagraphlineSpeace:(CGFloat)lineSpacing
                                           textColor:(UIColor *)textcolor
                                            textFont:(UIFont *)font;
@end
