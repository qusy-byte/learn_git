//
//  Flag.m
//  RAC
//
//  Created by SL on 16/8/29.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "Flag.h"

@implementation Flag

+ (instancetype)flagWithDict:(NSDictionary *)dict
{
    Flag *flag = [[self alloc] init];
    
    [flag setValuesForKeysWithDictionary:dict];
    
    return flag;
}

@end
