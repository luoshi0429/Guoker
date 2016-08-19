//
//  LMYSearchViewController.m
//  GuoKer
//
//  Created by Lumo on 16/8/10.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYSearchViewController.h"

@interface LMYSearchViewController ()

@end

@implementation LMYSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self p_setupUI];
    
    [self p_fetchKeywords];
}

- (void)p_setupUI
{
    self.view.backgroundColor = [UIColor redColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_ic_36x36_"] style:UIBarButtonItemStyleDone target:self action:@selector(p_search)];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.65, SearchNavBarTextFieldHeight);
    
    UITextField *searchTextField = [[UITextField alloc] init];
    [searchTextField becomeFirstResponder];
    searchTextField.font = [UIFont systemFontOfSize:16];
    searchTextField.textColor = [UIColor whiteColor];
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSAttributedString *attrStr = [[NSAttributedString alloc]
                                   initWithString:@"请输入关键字"
                                   attributes:@{
                                                NSForegroundColorAttributeName : LMYColor(100, 230, 160, 1),
                                                NSFontAttributeName : [UIFont systemFontOfSize:16]
                                                }];
    searchTextField.attributedPlaceholder = attrStr;
    searchTextField.frame =  titleView.bounds ;//CGRectMake(0, 0, SCREEN_WIDTH * 0.65, 38);
    [titleView addSubview:searchTextField];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor whiteColor];
    bottomLine.frame = CGRectMake(0, titleView.height - SeperatorLineHeight, titleView.width, SeperatorLineHeight);
    [titleView addSubview:bottomLine];
    
    self.navigationItem.titleView = titleView ;
}

/**
 *  获取关键词
 */
- (void)p_fetchKeywords
{
    [LMYNetworkTool lmy_get:Search_keywords params:nil success:^(id response) {
        LMYLog(@"关键字：%@",response);
    } failure:^(NSError *error) {
        LMYLog(@"关键字：%@",error);
    }];
}

- (void)p_search
{
    LMYLog(@"搜索");
}

@end
