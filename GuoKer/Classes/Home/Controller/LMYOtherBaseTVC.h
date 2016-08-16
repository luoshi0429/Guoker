//
//  LMYOtherBaseTVC.h
//  GuoKer
//
//  Created by Lumo on 16/8/16.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMYArticleModel.h"

@interface LMYOtherBaseTVC : UITableViewController
//@property (nonatomic, assign) LMYTopicType type ;
/**
 *  文章的类型
 *
 *  用setter方法而不用属性的好处在于：用属性会让外界都能改变type的值，用setter方法只有子类才能重写父类的方法
 */
- (LMYTopicType)type;
@end
