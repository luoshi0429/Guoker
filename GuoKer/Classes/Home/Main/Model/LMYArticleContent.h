//
//  LMYArticleContent.h
//  GuoKer
//
//  Created by Lumo on 16/8/13.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMYArticleContent : NSObject
@property (nonatomic, copy) NSString *content ;
@property (nonatomic,strong) NSArray *pics ;

@end

@interface LMYArticleContentPic : NSObject
@property (nonatomic, copy) NSString *descStr ;
@property (nonatomic, copy) NSString *url ;
@end
