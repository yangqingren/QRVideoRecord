
//
//  LBVideoRecordingViewController.m
//  Masonry
//
//  Created by 杨庆人 on 2018/11/8.
//  Copyright © 2018年 杨庆人. All rights reserved.
//

#import "LBVideoRecordViewController.h"
#import <SCRecorder.h>
#import <Masonry.h>
#import "SCRecordSession+qrRecordManager.h"
#import <LBLoadingView.h>
#import <LBToastView.h>

#define LB_VIDEO_MAX_TIME       30.0

@interface LBVideoRecordViewController ()<SCRecorderDelegate, SCAssetExportSessionDelegate>
@property (strong, nonatomic) UIView *scanPreviewView;  // 视频层
@property (strong, nonatomic) UIButton *captureRealBtn;  // 录制按钮
@property (strong, nonatomic) UIButton *recurBtn;  // 重录按钮
@property (strong, nonatomic) UIButton *saveBtn;  // 录制按钮
@property (strong, nonatomic) UIButton *closeBtn;  // close
@property (strong, nonatomic) SCRecorderToolsView *focusView; // 实时播放视图
@property (strong, nonatomic) CAShapeLayer *captureLayer; // 实时播放视图
@property (copy, nonatomic) NSString *SCRQuality; // 视频质量
@property (nonatomic, copy) NSString *videoFileName;    // 视频文件名
@end

@implementation LBVideoRecordViewController {
    SCRecorder *_recorder;
    SCRecordSession *_recordSession;
    //Preview
    SCPlayer *_player;
    //Video filepath
    NSString *VIDEO_OUTPUTFILE;
}

@synthesize delegate;

#pragma mark -setter/getter方法
- (UIView *)scanPreviewView {
    if (!_scanPreviewView) {
        _scanPreviewView = [[UIView alloc] init];
        _scanPreviewView.userInteractionEnabled = YES;
        _scanPreviewView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _scanPreviewView;
}

- (UIButton *)captureRealBtn {
    if (!_captureRealBtn) {
        _captureRealBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _captureRealBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_captureRealBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _captureRealBtn.layer.borderColor = [UIColor blueColor].CGColor;
        [_captureRealBtn setImage:[UIImage imageNamed:@"LBVideoRecord.bundle/startVideo"] forState:UIControlStateNormal];
        [_captureRealBtn setImage:[UIImage imageNamed:@"LBVideoRecord.bundle/endVideo"] forState:UIControlStateSelected];
        [_captureRealBtn addTarget:self action:@selector(captureStartTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        _captureRealBtn.layer.cornerRadius = 72 / 2.0;
        _captureRealBtn.layer.masksToBounds = YES;
    }
    return _captureRealBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"LBVideoRecord.bundle/close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)recurBtn {
    if (!_recurBtn) {
        _recurBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recurBtn setImage:[UIImage imageNamed:@"LBVideoRecord.bundle/recurVideo"] forState:UIControlStateNormal];
        [_recurBtn addTarget:self action:@selector(removePreviewMode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recurBtn;
}

- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setImage:[UIImage imageNamed:@"LBVideoRecord.bundle/nextVideo"] forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

- (void)prepareSession {
    if (_recorder.session == nil) {
        SCRecordSession *session = [SCRecordSession recordSession];
        session.fileType = AVFileTypeQuickTimeMovie;
        _recorder.session = session;
    }
}

- (instancetype)init {
    if (self = [super init]) {
        _videoMaxTime = LB_VIDEO_MAX_TIME;
        _SCRQuality = SCPresetMediumQuality;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareSession];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_recorder startRunning];  // 预览视频
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_recorder stopRunning];    // 停止预览
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:56/255.0 green:51/255.0 blue:49/255.0 alpha:1];
    
    [self.view addSubview:self.scanPreviewView];
    [self.scanPreviewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.captureRealBtn];
    [self.captureRealBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(72, 72));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.safeAreaInsets.bottom).offset(-60);
        } else {
            make.bottom.offset(-60);
            // Fallback on earlier versions
        }
    }];
    
    [self.view addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.left.offset(50);
        make.centerY.mas_equalTo(self.captureRealBtn.mas_centerY);
    }];
    
    // 视频输出路径
    VIDEO_OUTPUTFILE = [self generateFilePathWithType:@"mp4"];
    
    // 清晰度
    switch (self.recordQuality) {
        case LBVideoRecordHighestQuality:
            self.SCRQuality = SCPresetHighestQuality;
            break;
        case LBVideoRecordMediumQuality:
            self.SCRQuality = SCPresetMediumQuality;
            break;
        case LBVideoRecordLowQuality:
            self.SCRQuality = SCPresetLowQuality;
            break;
            
        default:
            break;
    }
    
    [self configRecorder];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_recorder previewViewFrameChanged];
}

- (void)doNextWhenVideoSavedSuccess {
    //file path is VIDEO_OUTPUTFILE
    if ([delegate respondsToSelector:@selector(finishVideoRecordCapture:filePath:fileName:)]) {
        [delegate finishVideoRecordCapture:[NSURL fileURLWithPath:VIDEO_OUTPUTFILE] filePath:VIDEO_OUTPUTFILE fileName:self.videoFileName];
    }
    [self closeAction:nil];
}

#pragma mark -录制地址
- (NSString *)generateFilePathWithType:(NSString *)fileType {
    self.videoFileName = [[self class] getVideoNameWithType:fileType];
    return  [[[self class] getVideoPathCache] stringByAppendingString:[NSString stringWithFormat:@"/%@",self.videoFileName]];
}

+ (NSString *)getVideoPathCache {
    NSString *videoCache = [NSTemporaryDirectory() stringByAppendingPathComponent:@"videos"] ;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:videoCache];
    if (!existed) {
        [fileManager createDirectoryAtPath:videoCache withIntermediateDirectories:YES attributes:nil error:nil];
    };
    return videoCache;
}

+ (NSString *)getVideoNameWithType:(NSString *)fileType {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate * NowDate = [NSDate dateWithTimeIntervalSince1970:now];
    NSString * timeStr = [formatter stringFromDate:NowDate];
    NSString *fileName = [NSString stringWithFormat:@"video_%@.%@",timeStr,fileType];
    return fileName;
}

#pragma mark -录制设置
- (void)configRecorder {
    // 录制设置
    _recorder = [SCRecorder recorder];
    _recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    _recorder.maxRecordDuration = CMTimeMake(30 * _videoMaxTime, 30);
    _recorder.delegate = self;
    _recorder.autoSetVideoOrientation = YES;
    _recorder.initializeSessionLazily = NO;
    _recorder.previewView = self.scanPreviewView;
    
    // 实时播放
    self.focusView = [[SCRecorderToolsView alloc] init];
    self.focusView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.focusView.recorder = _recorder;
    
    // 聚焦
    self.focusView.outsideFocusTargetImage = [UIImage imageNamed:@"WechatShortVideo_scan_focus"];
    
    [self.scanPreviewView addSubview:self.focusView];
    [self.focusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scanPreviewView);
    }];
    
    // 错误捕获
    NSError *error;
    if (![_recorder prepare:&error]) {
        NSLog(@"Prepare error: %@", error.localizedDescription);
    }
}

- (void)otherSet {
    // 闪光灯
    _recorder.flashMode = AVCaptureFlashModeOff;
    // 切换摄像头
    _recorder.device = AVCaptureDevicePositionBack;
    [_recorder switchCaptureDevices];
    // 缩放
    _recorder.videoZoomFactor = 2;
}

#pragma mark - 开始录制/结束录制
- (void)captureStartTouchUpInside:(UIButton *)captureBtn {
    captureBtn.selected = !captureBtn.selected;
    if (captureBtn.selected) {
        [_recorder record];  // 开始录制
        self.closeBtn.hidden = YES;
        if (self.captureLayer && self.captureLayer.superlayer) {
            [self.captureLayer removeFromSuperlayer];
            self.captureLayer = nil;
        }
        self.captureLayer = [self captureBtnLayer:self.captureRealBtn];
        [self.captureRealBtn.layer addSublayer:self.captureLayer];
    }
    else {
        self.closeBtn.hidden = NO;
        if (self.captureLayer && self.captureLayer.superlayer) {
            [self.captureLayer removeFromSuperlayer];
            self.captureLayer = nil;
        }
        [self cancelCaptureWithSaveFlag:YES];
    }
}

#pragma mark -录制相对最大时间进度条
- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    //update progressBar
    //    CGFloat durationTime = CMTimeGetSeconds(recordSession.duration);
    //    CGFloat progressWidthConstant = (VIDEO_MAX_TIME - durationTime) / VIDEO_MAX_TIME * self.middleTipView.frame.size.width;
    //    self.middleProgressViewWidthConstraint.constant = progressWidthConstant >= 0 ? progressWidthConstant : 0;
    
}

#pragma mark -录制最大时间
- (void)recorder:(SCRecorder *__nonnull)recorder didCompleteSession:(SCRecordSession *__nonnull)session {
    [self cancelCaptureWithSaveFlag:YES];
    self.captureRealBtn.selected = !self.captureRealBtn.selected;
    self.closeBtn.hidden = NO;
}

#pragma mark - 结束录制
- (void)cancelCaptureWithSaveFlag:(BOOL)saveFlag {
    // 停止录制
    [_recorder pause:^{
        if (saveFlag) {
            //Preview and save
            [self configPreviewMode];
        } else {
            //retake prepare
            SCRecordSession *recordSession = _recorder.session;
            if (recordSession != nil) {
                _recorder.session = nil;
                if ([recordSession qr_isSaved]) {
                    [recordSession endSegmentWithInfo:nil completionHandler:nil];
                } else {
                    [recordSession cancelSession:nil];
                }
            }
            [self prepareSession];
        }
    }];
}

#pragma mark - 播放预览；设置 重录按钮、保存按钮
- (void)configPreviewMode {
    if ([self.scanPreviewView viewWithTag:400]) {
        return;
    }
    self.captureRealBtn.enabled = NO;
    self.captureRealBtn.hidden = YES;
    self.closeBtn.hidden = YES;
    
    _player = [SCPlayer player];
    SCVideoPlayerView *playerView = [[SCVideoPlayerView alloc] initWithPlayer:_player];
    playerView.frame = self.scanPreviewView.bounds;
    playerView.tag = 400;
    playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerView.autoresizingMask = self.scanPreviewView.autoresizingMask;
    [self.scanPreviewView addSubview:playerView];
    _player.loopEnabled = YES;
    [_player setItemByAsset:_recorder.session.assetRepresentingSegments];
    [_player play];  // 开始播放
    
    [self.view addSubview:self.recurBtn];
    [self.view addSubview:self.saveBtn];
    
    [self.recurBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.safeAreaInsets.bottom).offset(-60);
        } else {
            make.bottom.offset(-60);
            // Fallback on earlier versions
        }
        make.left.offset(50);
        make.size.mas_equalTo(CGSizeMake(72, 72));
    }];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.safeAreaInsets.bottom).offset(-60);
        } else {
            make.bottom.offset(-60);
            // Fallback on earlier versions
        }
        make.right.offset(-50);
        make.size.mas_equalTo(CGSizeMake(72, 72));
    }];
}

#pragma mark -重录（移除预览）
- (void)removePreviewMode {
    self.captureRealBtn.enabled = YES;
    self.captureRealBtn.hidden = NO;
    self.closeBtn.hidden = NO;
    
    [_player pause];
    _player = nil;
    for (UIView *subview in self.scanPreviewView.subviews) {
        if (subview.tag == 400) {
            [subview removeFromSuperview];
        }
    }
    if (self.recurBtn.superview) {
        [self.recurBtn removeFromSuperview];
        self.recurBtn = nil;
    }
    if (self.saveBtn.superview) {
        [self.saveBtn removeFromSuperview];
        self.saveBtn = nil;
    }
    if (self.captureLayer && self.captureLayer.superlayer) {
        [self.captureLayer removeFromSuperlayer];
        self.captureLayer = nil;
    }
    [self cancelCaptureWithSaveFlag:NO];
}

- (void)saveBtnAction {
    if (self.doNextAction) {
        self.doNextAction();
        return;
    }
    [self saveCapture];
}

#pragma #pragma mark -视频质量处理、保存
- (void)saveCapture {
    [_player pause];
    void(^completionHandler)(NSURL *url, NSError *error) = ^(NSURL *url, NSError *error) {
        if (error == nil) {
            [LBLoadingView dismiss];
            [self doNextWhenVideoSavedSuccess];
        } else {
            [LBLoadingView dismiss];
            [self removePreviewMode];
            [LBToastView showByMessage:@"视频录制失败，内存不足"];
        }
    };
    
    // 视频开始处理
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:_recorder.session.assetRepresentingSegments];
    exportSession.videoConfiguration.preset = self.SCRQuality; // 视频质量
    exportSession.audioConfiguration.preset = self.SCRQuality; // 音频质量
    exportSession.videoConfiguration.maxFrameRate = 30;     // 最大帧数
    exportSession.outputUrl = [NSURL fileURLWithPath:VIDEO_OUTPUTFILE];
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.delegate = self;
    
    [LBLoadingView showInView:self.view];
    
    CFTimeInterval time = CACurrentMediaTime();
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        [_player play];
        NSLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        completionHandler(exportSession.outputUrl, exportSession.error);
    }];
}

#pragma mark - 视频质量处理进度
- (void)assetExportSessionDidProgress:(SCAssetExportSession *)assetExportSession {
    //    assetExportSession.progress;
}

#pragma mark - 关闭VC
- (void)closeAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 销毁VC
- (void)dealloc {
    _recorder.previewView = nil;
    [_player pause];
    _player = nil;
    NSLog(@"%@已释放",NSStringFromClass([self class]));
}

- (CAShapeLayer *)captureBtnLayer:(__kindof UIView *)view {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = view.bounds;
    
    CGFloat w = CGRectGetWidth(view.bounds);
    CGFloat h = CGRectGetHeight(view.bounds);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(w/2.0, h/2.0) radius:MIN(w, h)/2.0 startAngle:-M_PI_2 endAngle:3* M_PI_2 clockwise:YES];

    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 12.0f;
    
    shapeLayer.strokeColor = [UIColor colorWithRed:4/255.0 green:144/255.0 blue:226/255.0 alpha:1].CGColor;
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnima.duration = _videoMaxTime;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
    
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = YES;
    [shapeLayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
    
    return shapeLayer;
}

+ (UIImage*)getVideoPreViewImage:(NSURL *)url {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return img;
}

//计算文件大小
+ (CGFloat)fileSize:(NSURL *)path {
    return [[NSData dataWithContentsOfURL:path] length] / 1024.00 / 1024.00;
}

// 磁盘video文件夹
+ (NSString *)getVideoContents {
    return [self.class getVideoPathCache];
}

// 清理video文件夹
+ (BOOL)clearVideoContents {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:[self.class getVideoPathCache] error:nil];
}

@end
