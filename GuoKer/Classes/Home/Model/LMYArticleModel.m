//
//  LMYArticleModel.m
//  GuoKer
//
//  Created by Lumo on 16/8/13.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYArticleModel.h"
#import <MJExtension.h>
#import "LMYArticleContent.h"

@implementation LMYArticleModel

// 字典中的key是属性名，value是从字典中取值用的key
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"article_id" : @"id"
             };
}

- (NSString *)category_text
{
    if (!_category_text) {
        NSDictionary *texts = @{@"pic" : @"其他" ,@"entertainment" : @"娱乐" , @"life" : @"生活" , @"science" : @"科技" , @"health" : @"健康" ,@"learning" : @"学习" ,@"humanities" : @"人文",@"nature" : @"自然",@"mooc":@"其他"};
        _category_text = texts[self.category];
    }
    return _category_text ;
}

- (LMYArticleContent *)articleContent
{
    if (![self.category isEqualToString:@"calendar"] && self.content && ![self.content isEqualToString:@""]) {
    
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[self.content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        LMYArticleContent *articleContent = [LMYArticleContent mj_objectWithKeyValues:dict];
        return articleContent;
    }
    
    return nil;
}

@end
