//
//  Flag.h
//  RAC
//
//  Created by SL on 16/8/29.
//  Copyright © 2016年 SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flag : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *imgurl;
@property (nonatomic,copy) NSString *download;

+ (instancetype)flagWithDict:(NSDictionary *)dict;

@end
