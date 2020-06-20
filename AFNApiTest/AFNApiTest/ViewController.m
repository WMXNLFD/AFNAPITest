//
//  ViewController.m
//  AFNApiTest
//
//  Created by ios_ljp on 2020/6/18.
//  Copyright © 2020 ios_dev. All rights reserved.
//

#import "ViewController.h"
#import "UserModel.h"
#include "NSData+CRC32.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *resTextView;
@property (strong, nonatomic) UserModel *user;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)login:(UIButton *)sender {
    NSLog(@"登录");
    self.user = [[UserModel alloc] init];
    // 输入user 用户名 和密码信息
    self.user.userName = @"fffgrdcc@163.com";
    self.user.userPwd = @"123456";
    
    [self.user login:^(NSString * _Nonnull errorMessage) {
        NSLog(@"viewController : %@", errorMessage);
        self.resTextView.text = errorMessage;
    }];
    
    // 之后可以 根据 errorMessage 返回的信息 判断页面跳转
    
    // 授权 head 头
    
}

- (IBAction)logout:(UIButton *)sender {
    NSLog(@"登出");
    NSLog(@"登出获取jwt = %@", self.user.jwt);

    [self.user logout:^(NSString * _Nonnull errorMessage) {
        NSLog(@"viewController : %@", errorMessage);
    }];
}

- (IBAction)search:(UIButton *)sender {
    NSLog(@"搜索笔记");
    self.user.noteSearch = @"更新";
    
    [self.user searchNote:^(NSString * _Nonnull errorMessage) {
        NSLog(@"%@", errorMessage);
    }];
}

- (IBAction)newNote:(UIButton *)sender {
    NSLog(@"新建笔记");
//    self.user = [[UserModel alloc] init];
    self.user.title = @"test/a/b";
    self.user.content = @"testtesttesttest";
    self.user.is_public = YES;
    // 发送的 title + content 拼接
    NSString *sendString = [NSString stringWithFormat:@"%@%@", self.user.title, self.user.content];
    NSData *sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
    // CRC32算法
    int32_t checksum = [sendData crc32];
    self.user.checksum = [NSString stringWithFormat:@"%d", checksum];
    // 时间转换为 IOS_8601格式
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSString *dataStr = [formatter stringFromDate:date];
    NSLog(@"字符串时间 = %@",dataStr);
    self.user.local_update_at = [NSString stringWithFormat:@"%@", dataStr];
    
    [self.user newNote:^(NSString * _Nonnull errorMessage) {
        NSLog(@"viewController : %@", errorMessage);
        self.user.nid = errorMessage;
    }];
}

- (IBAction)nidGetNote:(UIButton *)sender {
    NSLog(@"根据 note id 获取笔记");
    NSLog(@"viewController nidGetNote :%@", self.user.nid);
    
    [self.user nidGetNote:^(NSString * _Nonnull errorMessage) {
        NSLog(@"viewController nidGetNote :%@", errorMessage);
    }];
}

- (IBAction)delNote:(UIButton *)sender {
    NSLog(@"删除笔记");
    NSLog(@"viewController delNote :%@", self.user.nid);
    
    [self.user delNote:^(NSString * _Nonnull errorMessage) {
        NSLog(@"viewController delNote : %@", errorMessage);
    }];
}

// 修改内容更新 笔记
- (IBAction)updateNote:(UIButton *)sender {
    NSLog(@"修改内容 更新笔记");
    //更新笔记的参数
    self.user.title = @"test/更新/gengxin";
    self.user.content = @"修改内容，更新笔记啊哈哈哈哈哈哈哈";
    self.user.is_public = NO;
    // 发送的 title + content 拼接
    NSString *sendString = [NSString stringWithFormat:@"%@%@", self.user.title, self.user.content];
    NSData *sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
    // CRC32算法
    int32_t checksum = [sendData crc32];
    self.user.checksum = [NSString stringWithFormat:@"%d", checksum];
    // 时间转换为 IOS_8601格式
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSString *dataStr = [formatter stringFromDate:date];
    NSLog(@"修改内容 更新后的字符串时间 = %@",dataStr);
    self.user.local_update_at = [NSString stringWithFormat:@"%@", dataStr];
    
    [self.user updateNote:^(NSString * _Nonnull errorMessage) {
        NSLog(@"viewController updateNote 修改笔记更新 : %@", errorMessage);
    }];
}

- (IBAction)getNotes:(UIButton *)sender {
    NSLog(@"获取笔记  全量");
    
    [self.user getNote:^(NSString * _Nonnull errorMessage) {
        NSLog(@"viewController getNote : %@", errorMessage);
    }];
}

- (IBAction)getNotesNetAndLocal:(UIButton *)sender {
    NSLog(@"获取笔记  差量");
    self.user.nid = @"5ed71f33f292bda3dac9fd38";
    self.user.checksum = @"790424313";
    self.user.local_update_at = @"2020-06-20T03:38:15";
    
    [self.user getNoteNetAndLoacl:^(NSString * _Nonnull errorMessage) {
        NSLog(@"viewController getNotesNetAndLocal : %@", errorMessage);
    }];
}


@end
