//
//  ZZGRunFlag.h
//  HHHAttribute
//
//  Created by 王会洲 on 17/1/10.
//  Copyright © 2017年 王会洲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZGRunFlag : NSObject
@property (nonatomic, strong) NSString *flag;
@property (nonatomic)         NSRange   range;

+ (ZZGRunFlag *)rangeFlagWithFlag:(NSString *)flag range:(NSRange)range;
@end
