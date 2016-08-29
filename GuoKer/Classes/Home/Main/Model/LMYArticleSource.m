//
//  LMYArticleSource.m
//  GuoKer
//
//  Created by Lumo on 16/8/13.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYArticleSource.h"
#import <MJExtension.h>
@implementation LMYArticleSource

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"source_id":@"id"
             };
}
@end
