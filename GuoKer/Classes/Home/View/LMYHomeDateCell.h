//
//  LMYHomeDateCell.h
//  GuoKer
//
//  Created by Lumo on 16/8/12.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMYHomeDateCell : UITableViewCell

@property (nonatomic, copy) NSString *pickedDateStr ;

+ (instancetype)homeDateCell:(UITableView *)tableView;
@end
