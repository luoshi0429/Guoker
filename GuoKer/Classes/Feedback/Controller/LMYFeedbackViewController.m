//
//  LMYFeedbackViewController.m
//  GuoKer
//
//  Created by Lumo on 16/8/8.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYFeedbackViewController.h"
#import <Masonry.h>
#import "LMYPlaceholderTextView.h"
#import <SVProgressHUD.h>

@interface LMYFeedbackViewController ()
@property (nonatomic, weak) UITextField *contactTextFiled ;
@property (nonatomic, weak) LMYPlaceholderTextView *commentTextView ;
@end

@implementation LMYFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_setupUI];
    
}

- (void)p_setupUI
{
    self.title = @"反馈";
    self.view.backgroundColor = LMYColor(236, 236, 236, 1);
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [commitBtn addTarget:self action:@selector(p_commit) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:commitBtn];
    
    UIView *contactContainerView = [[UIView alloc] init];
    contactContainerView.backgroundColor = LMYColor(208, 208, 208, 1);
    [self.view addSubview:contactContainerView];

    UITextField *contactTextfield = [[UITextField alloc] init];
    contactTextfield.font = [UIFont systemFontOfSize:17];
    contactTextfield.backgroundColor = [UIColor whiteColor];
    contactTextfield.placeholder = @"请留下您的QQ或邮箱";
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, 6, FeedbackContactTextFieldHeight);
    contactTextfield.leftView = leftView;
    contactTextfield.leftViewMode = UITextFieldViewModeAlways;
    [contactContainerView addSubview:contactTextfield];
    self.contactTextFiled = contactTextfield ;
    
    UIView *commentContainerView = [[UIView alloc] init];
    commentContainerView.backgroundColor = LMYColor(208, 208, 208, 1);
    [self.view addSubview:commentContainerView];
    
    LMYPlaceholderTextView *commentTextView = [[LMYPlaceholderTextView alloc] init];
    commentTextView.font = [UIFont systemFontOfSize:17];
    commentTextView.backgroundColor = [UIColor whiteColor];
    commentTextView.placeholder = @"请写下您的反馈";
    [commentContainerView addSubview:commentTextView];
    self.commentTextView = commentTextView ;
    
    [contactContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(FeedbackLeftRightTopMarigin + NavBarHeight));
        make.leading.equalTo(@(FeedbackLeftRightTopMarigin));
        make.trailing.equalTo(@(-FeedbackLeftRightTopMarigin));
        make.height.equalTo(@(FeedbackContactTextFieldHeight));
    }];
    
    [contactTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@1);
        make.trailing.bottom.equalTo(@-1);
    }];
    
    [commentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contactTextfield.mas_bottom).offset(FeedbackLeftRightTopMarigin);
        make.leading.trailing.equalTo(contactTextfield);
        make.height.equalTo(@(FeedbackContentTextViewHeight));
    }];
    
    [commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@1);
        make.trailing.bottom.equalTo(@-1);
    }];
    
}
#pragma mark - action
- (void)p_commit
{
    LMYLog(@"提交");
    BOOL cantactEmailRes = [self p_checkForContact:self.contactTextFiled.text];
    BOOL commentQQRes = [self p_checkForQQNumber:self.contactTextFiled.text];
    if (!cantactEmailRes && !commentQQRes) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的QQ或邮箱"];
        return ;
    }
    
    NSString *commentStr = [self.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (commentStr.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"要填写内容哦"];
        return ;
    }
    
    // 发送请求
    
    NSDictionary *params = @{
                             @"address" : self.contactTextFiled.text,
                             @"content" : self.commentTextView.text
                             };
    __weak typeof(self) weakSelf = self ;
    [LMYNetworkTool lmy_post:Feedback_url params:params success:^(id response) {
        LMYLog(@"%@",response);
        if ([response[@"ok"] isEqual:@1]) {
            [SVProgressHUD showSuccessWithStatus:@"感谢反馈"];
            weakSelf.contactTextFiled.text = @"";
            weakSelf.commentTextView.text = @"";
        }
    } failure:^(NSError *error) {
        LMYLog(@"feedback : %@",error);
    }];
}

- (BOOL)p_checkForContact:(NSString *)string
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:emailRegex options:NSRegularExpressionCaseInsensitive error:NULL];
    
    NSArray *resArr = [reg matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
     NSLog(@"email----%ld",resArr.count);
    return resArr.count > 0 ;
}

- (BOOL)p_checkForQQNumber:(NSString *)string
{
    // 5-12位数之间
    NSString *qqRegex = @"^[1-9]\\d{4,11}$";
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:qqRegex options:NSRegularExpressionCaseInsensitive error:NULL];
    
    NSArray *resArr = [reg matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    NSLog(@"qq----%ld",resArr.count);
    return resArr.count > 0 ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
