//
//  ZZGLabel.h
//  HHHAttribute
//
//  Created by 王会洲 on 17/1/10.
//  Copyright © 2017年 王会洲. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZZGLabel : UILabel

/**富文本字段*/
@property (nonatomic, strong) NSAttributedString * attributeString;



-(void)addLinkStringRange:(NSRange)range flag:(NSString *)flag;

/**渲染*/
-(void)ApplayDraw;
- (void)resetSize;



@end
