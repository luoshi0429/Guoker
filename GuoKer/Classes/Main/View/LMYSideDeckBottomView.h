//
//  LMYSideDeckBottomView.h
//  GuoKer
//
//  Created by Lumo on 16/8/8.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LMYSideDeckBottomViewDelegate <NSObject>

@optional
- (void)sideDeckBottomViewDidClickeAtIndex:(NSInteger)index;

@end

@interface LMYSideDeckBottomView : UIView

@property (nonatomic,strong ) NSArray *titles ;
@property (nonatomic, weak) id<LMYSideDeckBottomViewDelegate> delegate ;

@end
