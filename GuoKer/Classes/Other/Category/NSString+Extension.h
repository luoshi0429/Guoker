//
//  NSString+Extension.h
//  GuoKer
//
//  Created by Lumo on 16/8/29.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (NSString *)appendDocPath;
- (NSString *)appendCachePath;
- (NSString *)appendTmpPath;

@end
