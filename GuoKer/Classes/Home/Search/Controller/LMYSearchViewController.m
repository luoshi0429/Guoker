//
//  LMYSearchViewController.m
//  GuoKer
//
//  Created by Lumo on 16/8/10.
//  Copyright © 2016年 LM. All rights reserved.
//
#import "LMYSearchViewController.h"
#import "LMYKeywordView.h"
#import "LMYSearchCell.h"
#import "LMYSearchResult.h"
#import <MJExtension.h>
#import <MJRefresh.h>

@interface LMYSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *keywords ;
@property (nonatomic, weak) LMYKeywordView *keywordView ;
@property (nonatomic, weak) UITextField *searchTextField ;
@property (nonatomic, weak) UIButton *clearBtn ;
@property (nonatomic, weak) UITableView *tableView ;
@property (nonatomic,strong) NSMutableArray *searchResults ;
@property (nonatomic, copy) NSString *keyword ;

@end

@implementation LMYSearchViewController

#pragma mark - lazy
- (NSMutableArray *)keywords
{
    if (_keywords == nil)
    {
        _keywords = [[NSMutableArray alloc] init] ;
    }
    return _keywords ;
}

- (NSMutableArray *)searchResults
{
    if (_searchResults == nil)
    {
        _searchResults = [[NSMutableArray alloc] init] ;
    }
    return _searchResults ;
}

#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];

    [self p_setupUI];
    
    [self p_fetchKeywords];
}

- (void)p_setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_ic_36x36_"] style:UIBarButtonItemStyleDone target:self action:@selector(p_search)];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.65, SearchNavBarTextFieldHeight);
    
    CGFloat clearBtnWH = 22 ;
    UITextField *searchTextField = [[UITextField alloc] init];
    searchTextField.font = [UIFont systemFontOfSize:17];
    searchTextField.textColor = [UIColor whiteColor];
    [searchTextField addTarget:self action:@selector(p_textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.searchTextField = searchTextField ;
    NSAttributedString *attrStr = [[NSAttributedString alloc]
                                   initWithString:@"请输入关键字"
                                   attributes:@{
                                                NSForegroundColorAttributeName : LMYColor(100, 230, 160, 1),
                                                NSFontAttributeName : [UIFont systemFontOfSize:16]
                                                }];
    searchTextField.attributedPlaceholder = attrStr;
    searchTextField.frame =  CGRectMake(0, 0, titleView.width - clearBtnWH, titleView.height) ;
    [titleView addSubview:searchTextField];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBtn setImage:[UIImage imageNamed:@"clearBtn"] forState:UIControlStateNormal];
    clearBtn.width = clearBtnWH;
    clearBtn.height = clearBtnWH;
    clearBtn.centerY = searchTextField.height * 0.5;
    clearBtn.x = searchTextField.width;
    clearBtn.hidden = YES ;
    [titleView addSubview:clearBtn];
    self.clearBtn = clearBtn ;
    [clearBtn addTarget:self action:@selector(p_clearBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor whiteColor];
    bottomLine.frame = CGRectMake(0, titleView.height - SeperatorLineHeight, titleView.width, SeperatorLineHeight);
    [titleView addSubview:bottomLine];
    
    self.navigationItem.titleView = titleView ;
    
    LMYKeywordView *keywordView = [[LMYKeywordView alloc] initWithFrame:CGRectMake(0, NavBarHeight, self.view.width, self.view.height)];
    keywordView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:keywordView];
    self.keywordView = keywordView ;
    __weak typeof(self) weakSelf = self ;
    keywordView.keywordButtonClicked = ^(NSString *title){
        weakSelf.searchTextField.text = title ;
        weakSelf.keyword = title ;
        weakSelf.clearBtn.hidden = NO;
        [weakSelf p_searchForKeyword:title];
    };
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self ;
    tableView.delegate = self ;
    [tableView registerClass:[LMYSearchCell class] forCellReuseIdentifier:@"searchCell"];
    tableView.rowHeight = SearchCellHeight;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView ;
    [self.view insertSubview:tableView belowSubview:keywordView];
    
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf p_searchForKeyword:weakSelf.searchTextField.text];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchTextField resignFirstResponder];
}

#pragma makr - action
- (void)p_textFieldDidChange:(UITextField *)tf
{
    self.clearBtn.hidden = !tf.hasText;
}

- (void)p_clearBtnClicked
{
    self.searchTextField.text = @"";
    self.searchResults = nil;
    [self.tableView reloadData];
    [self.view insertSubview:self.keywordView  aboveSubview:self.tableView];
    self.clearBtn.hidden = YES ;
}

#pragma mark - data
/**
 *  获取关键词
 */
- (void)p_fetchKeywords
{
    __weak typeof(self) weakSelf = self;
    [LMYNetworkTool lmy_get:Search_keywords params:nil success:^(id response) {
//        LMYLog(@"关键字：%@",response);
        if ([response[@"ok"] isEqual:@1])
        {
            NSArray *items = [[response[@"result"] firstObject] objectForKey:@"items"];
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *dict in items)
            {
                NSString *text = dict[@"text"];
                if (text.length > 0)
                {
                    [tempArr addObject:dict[@"text"]];
                }
            }
            weakSelf.keywordView.keywords = tempArr ;
        }
    } failure:^(NSError *error) {
        LMYLog(@"关键字：%@",error);
    }];
}

- (void)p_search
{
    self.keyword = self.searchTextField.text ;
    [self p_searchForKeyword:self.keyword];
}

- (void)p_searchForKeyword:(NSString *)keyword
{
    [self.searchTextField resignFirstResponder];
    if (keyword.length == 0 || keyword == nil) {
        return ;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"offset"] = @(self.searchResults.count) ;
    params[@"limit"] = @20;
    params[@"wd"] = keyword ;
    __weak typeof(self) weakSelf = self ;
    [LMYNetworkTool lmy_get:Search_search params:params success:^(id response) {
//        LMYLog(@"search : %@",response);
        if (response[@"ok"]) {
            NSArray *tempArr = [LMYSearchResult mj_objectArrayWithKeyValuesArray:response[@"result"]];
            if (self.searchResults.count == 0) {
                weakSelf.searchResults = [tempArr mutableCopy] ;
                [weakSelf.view insertSubview:weakSelf.tableView aboveSubview:weakSelf.keywordView];
            }else{
                [weakSelf.searchResults addObjectsFromArray:tempArr];
            }
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        LMYLog(@"search error : %@",error);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMYSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    cell.searchResult = self.searchResults[indexPath.row];
    return cell;
}

#pragma make - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchTextField resignFirstResponder];
}

@end
