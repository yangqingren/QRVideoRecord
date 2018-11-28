//
//  QRVideoRecordViewController.m
//  Masonry
//
//  Created by 杨庆人 on 2018/11/19.
//

#import "QRVideoRecordViewController.h"
#import <SCRecorder/SCRecorder.h>
#import <Masonry/Masonry.h>
#import <SCRecordSession+qrRecordManager.h>
#import <MBProgressHUD/MBProgressHUD.h>

#define LB_VIDEO_MAX_TIME       30.0

@interface QRVideoRecordViewController ()<SCRecorderDelegate, SCAssetExportSessionDelegate>
@property (strong, nonatomic) UIView *scanPreviewView;  // video layer
@property (strong, nonatomic) UIButton *captureRealBtn;
@property (strong, nonatomic) UIButton *recurBtn;
@property (strong, nonatomic) UIButton *saveBtn;
@property (strong, nonatomic) UIButton *closeBtn;
@property (strong, nonatomic) SCRecorderToolsView *focusView; // view of video playing
@property (strong, nonatomic) CAShapeLayer *captureLayer; // recording progress layer
@property (copy, nonatomic) NSString *SCRQuality;
@property (nonatomic, copy) NSString *videoFileName;
@end

@implementation QRVideoRecordViewController {
    SCRecorder *_recorder;
    SCRecordSession *_recordSession;
    //Preview
    SCPlayer *_player;
    //Video filepath
    NSString *VIDEO_OUTPUTFILE;
}

@synthesize delegate;

#pragma mark -setter/getter
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
        [_captureRealBtn setImage:[UIImage imageNamed:@"QRVideoRecord.bundle/startVideo"] forState:UIControlStateNormal];
        [_captureRealBtn setImage:[UIImage imageNamed:@"QRVideoRecord.bundle/endVideo"] forState:UIControlStateSelected];
        [_captureRealBtn addTarget:self action:@selector(captureStartTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        _captureRealBtn.layer.cornerRadius = 72 / 2.0;
        _captureRealBtn.layer.masksToBounds = YES;
    }
    return _captureRealBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"QRVideoRecord.bundle/close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)recurBtn {
    if (!_recurBtn) {
        _recurBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recurBtn setImage:[UIImage imageNamed:@"QRVideoRecord.bundle/recurVideo"] forState:UIControlStateNormal];
        [_recurBtn addTarget:self action:@selector(removePreviewMode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recurBtn;
}

- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setImage:[UIImage imageNamed:@"QRVideoRecord.bundle/nextVideo"] forState:UIControlStateNormal];
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
        _SCRQuality = SCPresetHighestQuality;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareSession];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_recorder startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_recorder stopRunning];
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
    
    // Video output path
    VIDEO_OUTPUTFILE = [self generateFilePathWithType:@"mp4"];

    switch (self.recordQuality) {
        case QRVideoRecordHighestQuality:
            self.SCRQuality = SCPresetHighestQuality;
            break;
        case QRVideoRecordMediumQuality:
            self.SCRQuality = SCPresetMediumQuality;
            break;
        case QRVideoRecordLowQuality:
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
    if ([delegate respondsToSelector:@selector(finishVideoRecordCapture:filePath:fileName:)]) {
        [delegate finishVideoRecordCapture:[NSURL fileURLWithPath:VIDEO_OUTPUTFILE] filePath:VIDEO_OUTPUTFILE fileName:self.videoFileName];
    }
    [self closeAction:nil];
}

#pragma mark -video record path
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

#pragma mark -record setter
- (void)configRecorder {
    
    // record setter
    _recorder = [SCRecorder recorder];
    _recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    _recorder.maxRecordDuration = CMTimeMake(30 * _videoMaxTime, 30);
    _recorder.delegate = self;
    _recorder.autoSetVideoOrientation = NO;
    _recorder.initializeSessionLazily = NO;
    _recorder.previewView = self.scanPreviewView;
    
    // view of video playing
    self.focusView = [[SCRecorderToolsView alloc] init];
    self.focusView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.focusView.recorder = _recorder;
    
    // focusing
    self.focusView.outsideFocusTargetImage = [UIImage imageNamed:@"WechatShortVideo_scan_focus"];
    
    [self.scanPreviewView addSubview:self.focusView];
    [self.focusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scanPreviewView);
    }];
    
    // error capture
    NSError *error;
    if (![_recorder prepare:&error]) {
        NSLog(@"Prepare error: %@", error.localizedDescription);
    }
}

- (void)setFlashMode:(AVCaptureFlashMode)flashMode {
    _flashMode = flashMode;
    _recorder.flashMode = [@(flashMode) integerValue];
}

- (void)setDevicePosition:(AVCaptureDevicePosition)devicePosition {
    _devicePosition = devicePosition;
    _recorder.device = devicePosition;
}

#pragma mark - Start Video Record
- (void)captureStartTouchUpInside:(UIButton *)captureBtn {
    captureBtn.selected = !captureBtn.selected;
    if (captureBtn.selected) {
        [_recorder record];
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

#pragma mark -recording max date progress
- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    //update progressBar
    //    CGFloat durationTime = CMTimeGetSeconds(recordSession.duration);
    //    CGFloat progressWidthConstant = (VIDEO_MAX_TIME - durationTime) / VIDEO_MAX_TIME * self.middleTipView.frame.size.width;
    //    self.middleProgressViewWidthConstraint.constant = progressWidthConstant >= 0 ? progressWidthConstant : 0;
    
}

#pragma mark -recording max date
- (void)recorder:(SCRecorder *__nonnull)recorder didCompleteSession:(SCRecordSession *__nonnull)session {
    [self cancelCaptureWithSaveFlag:YES];
    self.captureRealBtn.selected = !self.captureRealBtn.selected;
    self.closeBtn.hidden = NO;
}

#pragma mark - end Video Record
- (void)cancelCaptureWithSaveFlag:(BOOL)saveFlag {
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

#pragma mark - Play preview set reset button and save button.
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
    [_player play];
    
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

#pragma mark -Recordings（remove preview）
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
    [self saveCapture];
}

#pragma #pragma mark -Video quality processing and preservation
- (void)saveCapture {
    [_player pause];
    void(^completionHandler)(NSURL *url, NSError *error) = ^(NSURL *url, NSError *error) {
        if (error == nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self removePreviewMode];
            [self doNextWhenVideoSavedSuccess];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self removePreviewMode];
            NSLog(@"Record failure");
        }
    };
    
    // Video start processing
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:_recorder.session.assetRepresentingSegments];
    exportSession.videoConfiguration.preset = self.SCRQuality; // Video quality
    exportSession.audioConfiguration.preset = self.SCRQuality; // Audio quality
    exportSession.videoConfiguration.maxFrameRate = 30;     // Max FPS
    exportSession.outputUrl = [NSURL fileURLWithPath:VIDEO_OUTPUTFILE];
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    CFTimeInterval time = CACurrentMediaTime();
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        [_player play];
        NSLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        completionHandler(exportSession.outputUrl, exportSession.error);
    }];
}

#pragma mark - Video quality processing progress
- (void)assetExportSessionDidProgress:(SCAssetExportSession *)assetExportSession {
    //    assetExportSession.progress;
}

#pragma mark - close VC
- (void)closeAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - dealloc
- (void)dealloc {
    _recorder.previewView = nil;
    [_player pause];
    _player = nil;
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
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

+ (CGFloat)fileSize:(NSURL *)path {
    return [[NSData dataWithContentsOfURL:path] length] / 1024.00 / 1024.00;
}

+ (NSString *)getVideoContents {
    return [self.class getVideoPathCache];
}

+ (BOOL)clearVideoContents {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:[self.class getVideoPathCache] error:nil];
}

@end

