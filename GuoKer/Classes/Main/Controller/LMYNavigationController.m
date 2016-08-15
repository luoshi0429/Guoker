//
//  LMYNavigationController.m
//  GuoKer
//
//  Created by Lumo on 16/8/10.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYNavigationController.h"

@interface LMYNavigationController ()

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
}


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
}

@end
