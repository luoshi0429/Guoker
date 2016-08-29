//
//  LMYNavigationController.m
//  GuoKer
//
//  Created by Lumo on 16/8/10.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYNavigationController.h"

@interface LMYNavigationController ()<UINavigationControllerDelegate>
@property (nonatomic, weak) id popDelegate ;
@end

@implementation LMYNavigationController

+ (void)load
{
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    
    NSDictionary *attrs = @{
                            NSFontAttributeName : [UIFont systemFontOfSize:18],
                            NSForegroundColorAttributeName : [UIColor whiteColor]
                            };
    [bar setTitleTextAttributes:attrs];
    
    bar.tintColor = [UIColor whiteColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popDelegate = self.interactivePopGestureRecognizer.delegate ;
    self.delegate = self ;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count == 0) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bar_menu_icon_36x36_"] style:UIBarButtonItemStyleDone target:self action:@selector(p_showSideDeck)];

    }else {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"bar_back_icon_36x36_"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [backBtn sizeToFit];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)backButtonClicked
{
    [self.view endEditing:YES];
    [self popViewControllerAnimated:YES];
}


- (void)p_showSideDeck
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LMYShowSideDeckNotification object:self];;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.childViewControllers[0]) { //
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    } else {
        self.interactivePopGestureRecognizer.delegate = nil ;
    }
}
@end
