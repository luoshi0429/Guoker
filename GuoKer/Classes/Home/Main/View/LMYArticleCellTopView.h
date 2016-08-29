//
//  LMYArticleCellTopView.h
//  GuoKer
//
//  Created by Lumo on 16/8/18.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMYArticleModel;
@interface LMYArticleCellTopView : UIView
@property (nonatomic,strong) LMYArticleModel *articleModel ;
@property (nonatomic, assign) BOOL hideCategortBtn ;
@end
