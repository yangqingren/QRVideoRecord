//
//  QRViewController.m
//  QRVideoRecord
//
//  Created by yangqingren on 11/19/2018.
//  Copyright (c) 2018 yangqingren. All rights reserved.
//

#import "QRViewController.h"
#import <QRVideoRecord/QRVideoRecordViewController.h>
@interface QRViewController ()

@end

@implementation QRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"title";
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    QRVideoRecordViewController *vc = [[QRVideoRecordViewController alloc] init];
    vc.delegate = (id<QRVideoRecordDelegate>)self;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
