//
//  LMYArticleModel.h
//  GuoKer
//
//  Created by Lumo on 16/8/13.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LMYTopicTypeScience,
    LMYTopicTypeLife,
    LMYTopicTypeHealth,
    LMYTopicTypeLearn,
    LMYTopicTypeHumanity,
    LMYTopicTypeNature,
    LMYTopicTypeEntertainment
}LMYTopicType;

@class LMYArticleSource,LMYArticleContent;
@interface LMYArticleModel : NSObject

@property (nonatomic, copy) NSString *link_v2_sync_img ;
@property (nonatomic, copy) NSString *source_name;
@property (nonatomic, copy) NSString *video_url ;
@property (nonatomic, assign) int video_duration ;
@property (nonatomic,strong ) NSArray *images ;
@property (nonatomic, copy) NSString *article_id ;
@property (nonatomic, copy) NSString *category ;
@property (nonatomic, copy) NSString *category_text ;
@property (nonatomic, copy) NSString *style ;
@property (nonatomic, copy) NSString *title ;
@property (nonatomic,strong) LMYArticleSource *source_data ;
@property (nonatomic, copy) NSString *headline_img_tb ;
@property (nonatomic, copy) NSString *link_v2 ;
@property (nonatomic, copy) NSString *date_picked ;
@property (nonatomic, assign) BOOL is_top ;
@property (nonatomic, copy) NSString *link ;
@property (nonatomic, copy) NSString *headline_img ;
@property (nonatomic, assign) int replies_count ;
@property (nonatomic, copy) NSString *page_source ;
@property (nonatomic, copy) NSString *author ;
@property (nonatomic, copy) NSString *summary ;
@property (nonatomic, copy) NSString *source ;
@property (nonatomic, copy) NSString *reply_root_id;
@property (nonatomic, copy) NSString *date_created ;
@property (nonatomic, copy) NSString *content ;
@property (nonatomic,strong) LMYArticleContent *articleContent ;

/**
 *  判断是否为其他日期
 */
@property (nonatomic, assign) BOOL isOtherDay ;

@end
