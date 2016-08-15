//
//  LMYThemeManager.m
//  GuoKer
//
//  Created by Lumo on 16/8/8.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "LMYThemeManager.h"

@implementation LMYThemeManager

static id _instance ;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance ;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (void)changeModeWithTheme:(Theme)theme
{
    [[NSUserDefaults standardUserDefaults] setObject:@(theme) forKey:ThemeModeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    if (theme == ThemeNight) {
       
        // 12 14 15
        navBar.barTintColor = LMYColor(12, 14, 15, 1);
        
        self.bgColor = [UIColor darkGrayColor];
        self.sideDeckBgColor = LMYColor(14, 16, 16, 1);
        // 77 86 97 。 26 27 28
        self.sideDeckSeparetorColor = LMYColor(26, 27, 28, 1);
        self.sideDeckTitleColor = LMYColor(120, 120, 120, 1);
        self.sideDeckCellBgColor = LMYColor(19, 21, 22, 1);
       
        self.homeTopTitleViewBgColor = LMYColor(19, 21, 23, 1);
        self.homeTopTitleColor = LMYColor(67, 67, 67, 1);
        self.homeTopTitleSelectedColor = LMYColor(12, 78, 38, 1);
        
    }else {
        // 24 163 75
        navBar.barTintColor = LMYColor(24, 163, 75, 1);
        
        self.bgColor = [UIColor orangeColor];
        self.sideDeckBgColor = LMYColor(55, 63, 75, 1);
        self.sideDeckSeparetorColor = LMYColor(77, 86, 97, 1);
        self.sideDeckTitleColor = [UIColor whiteColor];
        self.sideDeckCellBgColor = LMYColor(43, 49, 59, 1);
       
        self.homeTopTitleViewBgColor = LMYColor(249, 249, 249, 1);
        self.homeTopTitleColor = LMYColor(138, 138, 138, 1);
        self.homeTopTitleSelectedColor = LMYColor(13, 167, 76, 1);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ThemeChangeNotificationKey object:self];
}

@end
