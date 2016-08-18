//
//  LMYArticleViewController.m
//  GuoKer
//
//  Created by Lumo on 16/8/17.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYArticleViewController.h"

@interface LMYArticleViewController ()

@end

@implementation LMYArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
