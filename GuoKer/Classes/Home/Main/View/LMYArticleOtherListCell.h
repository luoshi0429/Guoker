//
//  LMYArticleOtherListCell.h
//  GuoKer
//
//  Created by Lumo on 16/8/13.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMYArticleModel;
@interface LMYArticleOtherListCell : UITableViewCell

@property (nonatomic,strong) LMYArticleModel *articleModel ;

- (CGFloat)cellHeight:(LMYArticleModel *)articleModel;
@end
