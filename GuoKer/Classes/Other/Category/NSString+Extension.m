//
//  NSString+Extension.m
//  GuoKer
//
//  Created by Lumo on 16/8/29.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
/**
 *  拼接document文件夹在沙盒的路径
 */
- (NSString *)appendDocPath
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [docPath stringByAppendingPathComponent:[self lastPathComponent]];
}

/**
 *  拼接cache文件夹在沙盒的路径
 */
- (NSString *)appendCachePath
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [cachePath stringByAppendingPathComponent:[self lastPathComponent]];
}

/**
 *  拼接临时文件夹在沙盒的路径
 */
- (NSString *)appendTmpPath
{
    NSString *tmpPath = NSTemporaryDirectory() ;
    return [tmpPath stringByAppendingPathComponent:[self lastPathComponent]];
}
@end
