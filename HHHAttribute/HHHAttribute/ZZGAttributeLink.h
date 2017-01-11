//
//  ZZGAttributeLink.h
//  HHHAttribute
//
//  Created by 王会洲 on 17/1/10.
//  Copyright © 2017年 王会洲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZGAttributeLink : NSObject
@property (readonly, nonatomic, strong) NSTextCheckingResult *result;

-(instancetype)initWithAttributeLink:(NSTextCheckingResult *)result ;

@end
