//
//  NSAttributedLabelLink.h
//  HHHAttribute
//
//  Created by zzg on 2018/4/9.
//  Copyright © 2018年 王会洲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedLabelLink : NSObject

@property (readonly, nonatomic, strong) NSTextCheckingResult *result;

@property (readonly, nonatomic, copy) NSDictionary *attributes;

@property (readonly, nonatomic, copy) NSDictionary *activeAttributes;

@property (readonly, nonatomic, copy) NSDictionary *inactiveAttributes;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
                  activeAttributes:(NSDictionary *)activeAttributes
                inactiveAttributes:(NSDictionary *)inactiveAttributes
                textCheckingResult:(NSTextCheckingResult *)result;

@end
