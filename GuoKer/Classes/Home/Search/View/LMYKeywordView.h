//
//  LMYKeywordView.h
//  GuoKer
//
//  Created by Lumo on 16/8/29.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMYKeywordView : UIView

@property (nonatomic,strong) NSArray *keywords ;
@property (nonatomic, copy) void (^keywordButtonClicked)(NSString *title) ;
@end
