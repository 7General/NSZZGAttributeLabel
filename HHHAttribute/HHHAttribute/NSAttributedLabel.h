//
//  NSAttributeLabel.h
//  HHHAttribute
//
//  Created by zzg on 2018/4/9.
//  Copyright © 2018年 王会洲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@class  NSAttributedLabelLink;

@interface NSAttributedLabel : UILabel

-(instancetype)init NS_UNAVAILABLE;
/* 富文本源 */
@property (readwrite, nonatomic, copy) NSAttributedString *attributedText;
/* 富文本属性设置 */
@property (nonatomic, strong) NSDictionary *linkAttributes;

@property (nonatomic, strong) NSDictionary *activeLinkAttributes;
@property (nonatomic, strong) NSDictionary *inactiveLinkAttributes;


- (void)setText:(id)text;

- (NSAttributedLabelLink *)addLinkToURL:(NSURL *)url
                               withRange:(NSRange)range;

@end
