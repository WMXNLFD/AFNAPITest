//
//  UserModel.h
//  AFNApiTest
//
//  Created by ios_ljp on 2020/6/19.
//  Copyright © 2020 ios_dev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject
//{
//    BOOL _is_public;
//}

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *jwt;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPwd;
//笔记的id
@property (strong, nonatomic) NSString *nid;
//搜索笔记
@property (strong, nonatomic) NSString *noteSearch;

// 笔记的信息
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (assign, nonatomic) BOOL is_public;
@property (strong, nonatomic) NSString *checksum;
@property (strong, nonatomic) NSString *local_update_at;


// 登录
- (void)login: (void(^)(NSString *errorMessage))completion;

// 登出
- (void) logout: (void(^)(NSString *errorMessage))completion;

// 新建笔记
- (void) newNote: (void(^)(NSString *errorMessage))completion;

// 删除笔记
- (void) delNote: (void(^)(NSString *errorMessage))completion;

// 根据nid 获取笔记
- (void) nidGetNote: (void(^)(NSString *errorMessage))completion;

// 更新笔记
- (void) updateNote: (void(^)(NSString *errorMessage))completion;

//搜索笔记
- (void) searchNote: (void(^)(NSString *errorMessage))completion;

// 获取笔记 全量
- (void) getNote: (void(^)(NSString *errorMessage))completion;

// 获取笔记 差量
- (void) getNoteNetAndLoacl: (void(^)(NSString *errorMessage))completion;

@end

NS_ASSUME_NONNULL_END
