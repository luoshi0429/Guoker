//
//  LMYArticleListCell.h
//  GuoKer
//
//  Created by Lumo on 16/8/12.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMYArticleModel;
@interface LMYArticleListCell : UITableViewCell

@property (nonatomic,strong) LMYArticleModel *articleModel ;
@property (nonatomic, assign) BOOL hideCategortBtn ;

+ (instancetype)articleListCell:(UITableView *)tableView;
@end
