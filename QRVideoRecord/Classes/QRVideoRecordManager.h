//
//  QRVideoRecordManager.h
//  Masonry
//
//  Created by 杨庆人 on 2018/11/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRVideoRecordManager : NSObject
/**
 * cut out video preview
 * @param url video local url
 * @return video preview
 * video preview expect get video the first frame
 */
+ (UIImage*)getVideoPreViewImage:(NSURL *)url;

/**
 * calculation out video file size
 * @param path video local url
 * @return video size
 * video size unit is MB
 */
+ (CGFloat)fileSize:(NSURL *)path;

/**
 * disk address
 * you can get the video folder stored in the local sandbox, so that you can manage the sandbox storage.
 */
+ (NSString *)getVideoContents;

/**
 * clear video disk folder
 * if the memory of the mobile phone is too small, the video recording will fail. We hope to clean up the video files in the local sandbox when the page is destroyed.
 */
+ (BOOL)clearVideoContents;

@end

NS_ASSUME_NONNULL_END
