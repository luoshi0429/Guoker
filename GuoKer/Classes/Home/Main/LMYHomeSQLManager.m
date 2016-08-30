//
//  LMYHomeSQLManager.m
//  GuoKer
//
//  Created by Lumo on 16/8/29.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYHomeSQLManager.h"
#import <FMDB.h>
#import "NSString+Extension.h"
#import "LMYArticleModel.h"
@interface LMYHomeSQLManager()
@property (nonatomic,strong) FMDatabaseQueue *dbQueue ;

@end

@implementation LMYHomeSQLManager

static id _instance = nil;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance ;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance ;
}

- (instancetype)init
{
    if(self = [super init]){
        // 创建数据库
        NSString *path = [@"jingxuan_sqlite" appendCachePath];
        FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        self.dbQueue = dbQueue ;
        // 建表
        [self p_createArticleTable];
    }
    return self;
}

- (void)p_createArticleTable
{
    NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ \
                                                    (reply_root_id TEXT PRIMARY KEY, source_name TEXT, category TEXT, user_id TEXT, collect_time TEXT, collect TEXT, summary TEXT, id TEXT, title TEXT, author TEXT, content TEXT, source TEXT, date_created TEXT, link TEXT, date_picked TEXT)",HomeArticleTableName];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdate:createSQL]) {
            LMYLog(@"创建表格成功");
        }else {
            LMYLog(@"创建表格失败");
        }
    }];
}

- (void)saveArticleToDB:(NSArray *)articles
{
    for (LMYArticleModel *article in articles) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (reply_root_id,source_name,,category,user_id,collect_time,summary,collect,id,title,author,content,source,data_created,link,date_picked) VALUES (%@,%@,%@,%@)"];
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
        }];

    }
}

- (void)loadArticleFromDB
{
    
}
@end
