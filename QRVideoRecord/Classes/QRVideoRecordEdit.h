//
//  QRVideoRecordEdit.h
//  Masonry
//
//  Created by 杨庆人 on 2018/11/21.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface QRVideoRecordEdit : NSObject

/**
 timeRange
 
 * @param url video path
 * @param startTime
   CMTimeMakeWithSeconds(0, videoAsset.duration.timescale);
 
 * @param endTime
   CMTimeMakeWithSeconds(videoAsset.duration.value /videoAsset.duration.timescale, videoAsset.duration.timescale);
 
 * CMTimeMake(a,b)
   CMTimeMakeWithSeconds(a,b)
 
 * @param fileName video name .mp4
 * @param completion urlPath
 */
+ (void)videoEditByTimeRangeWithUrl:(NSURL *)url startTime:(CMTime)startTime endTime:(CMTime)endTime fileName:(NSString *)fileName completion:(void (^)(NSString *urlPath))completion;

/**
 Expression or watermark
 
 * @param url video path
 * @param image The expression and watermark you need to add
 * @param frame The expression you need to add and the location of the watermark.
 * @param fileName video name .mp4
 * @param completion urlPath
 */
+ (void)videoEditByImageWithUrl:(NSURL *)url image:(UIImage *)image frame:(CGRect)frame fileName:(NSString *)fileName completion:(void (^)(NSString *urlPath))completion;

/**
 Text or barrage
 
 * @param url video path 
 * @param textLayer The text or barrage you need to add
 * @param frame The text you need to add and the location of the watermark.
 * @param fileName video name .mp4
 * @param completion urlPath
 */
+ (void)videoEditByTextWithUrl:(NSURL *)url textLayer:(CATextLayer *)textLayer frame:(CGRect)frame fileName:(NSString *)fileName completion:(void (^)(NSString *urlPath))completion;

@end

