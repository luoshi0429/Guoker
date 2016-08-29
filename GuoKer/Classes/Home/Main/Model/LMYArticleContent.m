//
//  LMYArticleContent.m
//  GuoKer
//
//  Created by Lumo on 16/8/13.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYArticleContent.h"
#import <MJExtension.h>

@implementation LMYArticleContent

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"pics" : @"LMYArticleContentPic"
             };
}

@end

@implementation LMYArticleContentPic

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"descStr" : @"description"
             };
}


@end