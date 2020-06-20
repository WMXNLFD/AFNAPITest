//
//  UserModel.m
//  AFNApiTest
//
//  Created by ios_ljp on 2020/6/19.
//  Copyright © 2020 ios_dev. All rights reserved.
//

#import "UserModel.h"
#import "AFNetworking.h"

@interface UserModel()

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation UserModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [[AFHTTPSessionManager alloc]init];
        // 设置json 序列化
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

// 登录
- (void)login:(void (^)(NSString * _Nonnull))completion{
    NSString *urlString = @"https://mainote.maimemo.com/api/auth/login";
    NSDictionary *parameters = @{@"identity":self.userName,
                                @"password":self.userPwd
    };
    [self.manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功返回的信息
        NSLog(@"UserModel : %@", responseObject);
        self.uid = responseObject[@"id"];
        self.jwt = responseObject[@"jwt"];
        
        // 授权header jwt
        NSString *formatJwt = [NSString stringWithFormat:@"Bearer %@", self.jwt];
        [self.manager.requestSerializer setValue:formatJwt forHTTPHeaderField:@"Authorization"];
        
        if(completion){
            completion(@"Success");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 错误返回的信息
//        NSLog(@"UserModel : code = %ld domain = %@ userInfo = %@", (long)error.code, error.domain, error.userInfo);
        
        // 封装调用
        if(completion) {
            NSDictionary *errorDict = [self dealErrorMessage:error];
            completion(errorDict[@"message"]);
//            switch ([errorDict[@"error"] intValue]) {
//                case 400:
////                    completion(@"账号或密码错误");
//                    completion(errorDict[@"message"]);
//                    return;
//                case 500:
//                    completion(errorDict[@"message"]);
//                    return;
//                default:
//                    return;;
//            }
        }
        
        //处理错误信息
//        NSData *messageData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
//
//        NSLog(@"messageData = %@", messageData);
//
//        NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:messageData options:0 error:nil];
//
//        NSLog(@"errorDict = %@", errorDict);
        
        
    }];
}

// 登出
- (void)logout:(void (^)(NSString * _Nonnull))completion {
    NSString *urlString = @"https://mainote.maimemo.com/api/auth/logout";
    
    [self.manager POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功执行的操作
        if(completion) {
            completion(@"Success");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败执行的操作
        if(completion) {
            NSDictionary *errorDict = [self dealErrorMessage:error];
            completion(errorDict[@"message"]);
        }
    }];
}

// 创建新笔记
- (void)newNote:(void (^)(NSString * _Nonnull))completion {
    NSString *urlString = @"https://mainote.maimemo.com/api/note";
    NSDictionary *parameters = @{@"title":self.title,
                                 @"content":self.content,
                                 @"is_public":[NSNumber numberWithBool:self.is_public],
                                 @"checksum":self.checksum,
                                 @"local_updated_at":self.local_update_at,
    };
    
    [self.manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功创建笔记执行的操作
        NSLog(@"%@", responseObject);
        if(completion) {
//            completion(@"Success");
            completion(responseObject[@"id"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败创建笔记执行的操作
        if(completion) {
            NSDictionary *errorDict = [self dealErrorMessage:error];
            completion(errorDict[@"message"]);
        }
    }];
}

// 删除笔记
- (void)delNote:(void (^)(NSString * _Nonnull))completion {
    NSString *urlString = @"https://mainote.maimemo.com/api/notes";
    NSString *urlStringWithNoteId = [NSString stringWithFormat:@"%@/%@", urlString, self.nid];
    
    [self.manager DELETE:urlStringWithNoteId parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功删除执行的操作
        if(completion) {
            completion(@"Del Success");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败删除执行的操作
        if(completion) {
            NSDictionary *errorDict = [self dealErrorMessage:error];
            completion(errorDict[@"message"]);
        }
    }];
}

// 根据nid获取笔记
- (void)nidGetNote:(void (^)(NSString * _Nonnull))completion {
    NSString *urlString = @"https://mainote.maimemo.com/api/notes";
    NSString *urlStringWithNoteId = [NSString stringWithFormat:@"%@/%@", urlString, self.nid];
    
    [self.manager GET:urlStringWithNoteId parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功获取执行的操作
        if(completion) {
            completion(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败获取执行的操作
        if(completion) {
            NSDictionary *errorDict = [self dealErrorMessage:error];
            completion(errorDict[@"message"]);
        }
    }];
}

// 更新笔记
- (void)updateNote:(void (^)(NSString * _Nonnull))completion {
    NSString *urlString = @"https://mainote.maimemo.com/api/notes";
    NSString *urlStringWithNoteId = [NSString stringWithFormat:@"%@/%@", urlString, self.nid];
    // 更新笔记的参数
    NSDictionary *parameters = @{@"title":self.title,
                                 @"content":self.content,
                                 @"is_public":[NSNumber numberWithBool:self.is_public],
                                 @"checksum":self.checksum,
                                 @"local_updated_at":self.local_update_at,
    };
    
    [self.manager PATCH:urlStringWithNoteId parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功更新笔记执行的操作
        if(completion) {
            completion(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败更新笔记执行的操作
        if(completion) {
            NSDictionary *errorDict = [self dealErrorMessage:error];
            completion(errorDict[@"message"]);
       }
   }];
}

// 搜索笔记
- (void) searchNote:(void (^)(NSString * _Nonnull))completion {
    NSString *urlString = @"https://mainote.maimemo.com/api/notes";
    // 搜索笔记的参数
    NSDictionary *parameters = @{@"search":self.noteSearch,
    };
    
    [self.manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功搜索笔记执行的操作
        if(completion) {
            completion(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败搜索笔记执行的操作
        if(completion) {
             NSDictionary *errorDict = [self dealErrorMessage:error];
             completion(errorDict[@"message"]);
        }
    }];
}

// 获取我的笔记列表（差量）
- (void)getNoteNetAndLoacl:(void (^)(NSString * _Nonnull))completion {
    NSString *urlString = @"https://mainote.maimemo.com/api/notes/sync";
    // 差量获取笔记的参数
    NSDictionary *parametersNote = @{@"local_updated_at":self.local_update_at,
                                 @"checksum":self.checksum,
    };
    // 嵌套字典
//    NSDictionary *parameters = @{ @[@"%@", self.nid]: parametersNote};
//    NSDictionary *parameters = @{ @[self.nid]: parametersNote};
    NSDictionary *parameters = @{ self.nid: parametersNote};
    
    [self.manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功
        if(completion) {
            completion(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败
        if(completion) {
            NSDictionary *errorDict = [self dealErrorMessage:error];
            completion(errorDict[@"message"]);
        }
    }];
    
}

// 获取我的笔记列表（全量）
- (void)getNote:(void (^)(NSString * _Nonnull))completion {
    NSString *urlString = @"https://mainote.maimemo.com/api/notes";
    
    [self.manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功获取执行的操作
        if(completion) {
            completion(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败获取执行的操作
        if(completion) {
            NSDictionary *errorDict = [self dealErrorMessage:error];
            completion(errorDict[@"message"]);
        }
    }];
}

// 处理服务器返回错误信息
- (NSDictionary *)dealErrorMessage:(NSError *)error {
     
    // 从error.userInfo 取里面的 error data
    NSData *messageData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    NSLog(@"UserModel messageData = %@", messageData);
    
    NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:messageData options:0 error:nil];
    
    NSLog(@"UserModel errorDict = %@", errorDict);
    
    return errorDict;
}

@end
