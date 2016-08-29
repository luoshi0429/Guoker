//
//  LMYKeyword.m
//  GuoKer
//
//  Created by Lumo on 16/8/29.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYSearchResult.h"
#import <MJExtension.h>
@implementation LMYSearchResult

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"article_id" : @"id"
             };
}

@end
