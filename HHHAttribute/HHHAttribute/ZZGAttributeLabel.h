//
//  ZZGAttributeLabel.h
//  HHHAttribute
//
//  Created by 王会洲 on 17/1/10.
//  Copyright © 2017年 王会洲. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZGAttributeLabel;
@protocol ZZGAttributeLabelDelegate <NSObject>
@optional
-(void)ZZGLabel:(ZZGAttributeLabel *)label didSelectWith:(NSString *)content;


@end

@interface ZZGAttributeLabel : UILabel

+(instancetype)ZZGLabel;

@property (nonatomic, weak) id<ZZGAttributeLabelDelegate> delegate;

/**富文本字段*/
@property (nonatomic, strong) NSAttributedString * attributeString;

-(void)addLinkStringRange:(NSRange)range flag:(NSString *)flag;

/**渲染*/
-(void)ApplayDraw;
@end
