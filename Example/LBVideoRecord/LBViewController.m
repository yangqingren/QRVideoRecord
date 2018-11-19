//
//  LBViewController.m
//  LBVideoRecord
//
//  Created by yangqingren on 11/12/2018.
//  Copyright (c) 2018 yangqingren. All rights reserved.
//

#import "LBViewController.h"
#import <Masonry.h>
#import <WechatShortVideoController.h>
#import "LBVideoRecordViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LBViewController ()

@end

@implementation LBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationController.navigationBar setTranslucent:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"title";
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    LBVideoRecordViewController *vc = [[LBVideoRecordViewController alloc] init];
    vc.delegate = (id<LBVideoRecordDelegate>)self;
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)finishVideoRecordCapture:(NSURL *)fileURL filePath:(NSString *)filePath {
    NSLog(@"文件大小：%f MB",[LBVideoRecordViewController fileSize:fileURL]);
    NSLog(@"文件路径：%@",fileURL);
    UIImage *image = [LBVideoRecordViewController getVideoPreViewImage:fileURL];
}


@end
