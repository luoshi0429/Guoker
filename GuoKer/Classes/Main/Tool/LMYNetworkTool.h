//
//  LMYNetworkTool.h
//  GuoKer
//
//  Created by Lumo on 16/8/11.
//  Copyright © 2016年 LM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface LMYNetworkTool : NSObject

/** 
 *GET方法
 */
+ (void)lmy_get:(NSString *)urlString params:(id)params success: (void (^)(id response))success failure:(void (^)(NSError *error))failure ;

/** 
 *POST方法
 */
+ (void)lmy_post:(NSString *)urlString params:(id)params success:(void (^)(id response))success failure:(void (^)(NSError *error))failure ;

/** 
 *上传 
 */
+ (void)lmy_POST:(NSString *)urlString parameters:(id)params constructiongBodyWithBody:(void(^)(id<AFMultipartFormData> formData))block progress:(void (^)(NSProgress * uploadProgress))progress success:(void (^)(id response))success failure:(void (^)(NSError *error))failure ;

@end
