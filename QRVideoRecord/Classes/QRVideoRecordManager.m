//
//  QRVideoRecordManager.m
//  Masonry
//
//  Created by 杨庆人 on 2018/11/21.
//

#import "QRVideoRecordManager.h"
#import <AVFoundation/AVFoundation.h>
#import "QRVideoRecordViewController.h"

@implementation QRVideoRecordManager

/**
 * cut out video preview
 * @param url video local url
 * @return video preview
 * video preview expect get video the first frame
 */
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

/**
 * calculation out video file size
 * @param path video local url
 * @return video size
 * video size unit is MB
 */
+ (CGFloat)fileSize:(NSURL *)path {
    return [[NSData dataWithContentsOfURL:path] length] / 1024.00 / 1024.00;
}

/**
 * disk address
 * you can get the video folder stored in the local sandbox, so that you can manage the sandbox storage.
 */
+ (NSString *)getVideoContents {
    return [QRVideoRecordViewController getVideoContents];
}

/**
 * clear video disk folder
 * if the memory of the mobile phone is too small, the video recording will fail. We hope to clean up the video files in the local sandbox when the page is destroyed.
 */
+ (BOOL)clearVideoContents {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:[QRVideoRecordViewController getVideoContents] error:nil];
}
@end
