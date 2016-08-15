//
//  LMYThemeManager.h
//  GuoKer
//
//  Created by Lumo on 16/8/8.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ThemeNight,
    ThemeDay
}Theme;

@interface LMYThemeManager : NSObject

@property (nonatomic,strong ) UIColor *bgColor ;
@property (nonatomic,strong ) UIColor *sideDeckBgColor ;
@property (nonatomic,strong ) UIColor *sideDeckSeparetorColor ;
@property (nonatomic,strong ) UIColor *sideDeckTitleColor ; 
@property (nonatomic,strong ) UIColor *sideDeckCellBgColor ;

@property (nonatomic,strong ) UIColor *homeTopTitleViewBgColor ;
@property (nonatomic,strong ) UIColor *homeTopTitleColor ;
@property (nonatomic,strong ) UIColor *homeTopTitleSelectedColor ;



+ (instancetype)sharedManager;
- (void)changeModeWithTheme:(Theme)theme;



@end
