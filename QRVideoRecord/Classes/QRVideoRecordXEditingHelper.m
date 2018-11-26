

//
//  QRVideoRecordEdit.m
//  Masonry
//
//  Created by 杨庆人 on 2018/11/21.
//

#import "QRVideoRecordXEditingHelper.h"

@implementation QRVideoRecordXEditingHelper

/**
 timeRange
 
 * @param url video path
 * @param startTime
   CMTimeMakeWithSeconds(0, videoAsset.duration.timescale);
 
 * @param endTime
 * CMTimeMake(a,b)
   CMTimeMakeWithSeconds(a,b)
 
 * @param fileName video name .mp4
 * @param completion urlPath
 
 * If you need clipping video clips, then insert startTime and endTime to intercept the video.The parameters of video interception should be noted in CMTime format.
 */
+ (void)videoEditByTimeRangeWithUrl:(NSURL *)url startTime:(CMTime)startTime endTime:(CMTime)endTime fileName:(NSString *)fileName completion:(void (^)(NSString *urlPath))completion {
    
    if (!url) return;
    
    // 1. create AVAsset contains all the information of video.
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(YES) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:url options:opts];
    
    // 2. create AVMutableComposition. apple developer
    // AVMutableComposition is a mutable subclass of AVComposition you use when you want to create a new composition from existing assets. You can add and remove tracks, and you can add, remove, and scale time ranges.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    // 3. Video channel
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(startTime, endTime)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    
    // Audio channel
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // Audio acquisition channel
    AVAssetTrack *audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    [audioTrack insertTimeRange:CMTimeRangeMake(startTime, endTime) ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    // 3.1 AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoTrack.timeRange.duration);
    
    // 3.2 AVMutableVideoCompositionLayerInstruction
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    BOOL isVideoAssetPortrait  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        isVideoAssetPortrait = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        isVideoAssetPortrait = YES;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:endTime];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    //AVMutableVideoComposition：Managing all video tracks can determine the size of the final video, and the clipping needs to be done here.
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    CGSize naturalSize;
    if(isVideoAssetPortrait){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 25);
    
    // 4. putout path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",fileName]];
    unlink([myPathDocs UTF8String]);
    NSURL* videoUrl = [NSURL fileURLWithPath:myPathDocs];
    
    // 5. putout
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = videoUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ? :completion(videoUrl.path);
        });
    }];
}


/**
 expression or watermark
 
 * @param url video path
 * @param image The expression and watermark you need to add
 * @param frame The expression you need to add and the location of the watermark.
 * @param fileName video name .mp4
 * @param completion urlPath
 */
+ (void)videoEditByImageWithUrl:(NSURL *)url image:(UIImage *)image frame:(CGRect)frame fileName:(NSString *)fileName completion:(void (^)(NSString *urlPath))completion {
    
    if (!url) return;
    
    // 1. create AVAsset contains all the information of video.
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(YES) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:url options:opts];
    
    // 2. create AVMutableComposition. apple developer
    // AVMutableComposition is a mutable subclass of AVComposition you use when you want to create a new composition from existing assets. You can add and remove tracks, and you can add, remove, and scale time ranges.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    // 3. Video Channel
    // Engineering Document track, audio track, video track, etc., which can be inserted into a variety of corresponding materials
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime startTime = CMTimeMakeWithSeconds(0, videoAsset.duration.timescale);
    CMTime endTime = CMTimeMakeWithSeconds(videoAsset.duration.value /videoAsset.duration.timescale, videoAsset.duration.timescale);
    [videoTrack insertTimeRange:CMTimeRangeMake(startTime, endTime)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    
    // Audio channel
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // Audio acquisition channel
    AVAssetTrack *audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    [audioTrack insertTimeRange:CMTimeRangeMake(startTime, endTime) ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    // 3.1 AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoTrack.timeRange.duration);
    
    // 3.2 AVMutableVideoCompositionLayerInstruction
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    BOOL isVideoAssetPortrait  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        isVideoAssetPortrait = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        isVideoAssetPortrait = YES;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:endTime];
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    //AVMutableVideoComposition：Managing all video tracks can determine the size of the final video, and the clipping needs to be done here.
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 25);
    
    CALayer *imgLayer = [CALayer layer];
    imgLayer.contents = (id)image.CGImage;
    imgLayer.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
    imgLayer.position = frame.origin;
    
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:imgLayer];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, renderWidth, renderHeight);
    videoLayer.frame = CGRectMake(0, 0, renderWidth, renderHeight);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    mainCompositionInst.animationTool = [AVVideoCompositionCoreAnimationTool
                                         videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    // 4 - putout path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",fileName]];
    unlink([myPathDocs UTF8String]);
    NSURL* videoUrl = [NSURL fileURLWithPath:myPathDocs];
    
    // 5. putout
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = videoUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ? :completion(videoUrl.path);
        });
    }];
}

/**
 text or barrage
 
 * @param url video path 
 * @param textLayer The text or barrage you need to add
 * @param frame The text you need to add and the location of the watermark.
 * @param fileName video name .mp4
 * @param completion urlPath
 */
+ (void)videoEditByTextWithUrl:(NSURL *)url textLayer:(CATextLayer *)textLayer frame:(CGRect)frame fileName:(NSString *)fileName completion:(void (^)(NSString *urlPath))completion {
    
    if (!url) return;
    
    // 1. create AVAsset AVAsset contains all the information of video.
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(YES) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:url options:opts];
    
    // 2. create AVMutableComposition. apple developer
    // AVMutableComposition is a mutable subclass of AVComposition you use when you want to create a new composition from existing assets. You can add and remove tracks, and you can add, remove, and scale time ranges.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    // 3. Video Channel
    // Engineering Document track, audio track, video track, etc., which can be inserted into a variety of corresponding materials
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CMTime startTime = CMTimeMakeWithSeconds(0, videoAsset.duration.timescale);
    CMTime endTime = CMTimeMakeWithSeconds(videoAsset.duration.value /videoAsset.duration.timescale, videoAsset.duration.timescale);
    [videoTrack insertTimeRange:CMTimeRangeMake(startTime, endTime)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    
    // Audio channel
    AVMutableCompositionTrack * audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    // Audio acquisition channel
    AVAssetTrack * audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    [audioTrack insertTimeRange:CMTimeRangeMake(startTime, endTime) ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    // 3.1 AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoTrack.timeRange.duration);
    
    // 3.2 AVMutableVideoCompositionLayerInstruction
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    BOOL isVideoAssetPortrait  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        isVideoAssetPortrait = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        isVideoAssetPortrait = YES;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:endTime];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    //AVMutableVideoComposition：Managing all video tracks can determine the size of the final video, and the clipping needs to be done here.
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    CGSize naturalSize;
    if(isVideoAssetPortrait){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 25);
    
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:textLayer];
    overlayLayer.frame = frame;
    [overlayLayer setMasksToBounds:YES];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, renderWidth, renderHeight);
    videoLayer.frame = CGRectMake(0, 0, renderWidth, renderHeight);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    mainCompositionInst.animationTool = [AVVideoCompositionCoreAnimationTool
                                         videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    // 4 - putout path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",fileName]];
    unlink([myPathDocs UTF8String]);
    NSURL* videoUrl = [NSURL fileURLWithPath:myPathDocs];
    
    // 5. putout
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = videoUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ? :completion(videoUrl.path);
        });
    }];
}

@end
