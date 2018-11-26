#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "QRVideoRecord.h"
#import "QRVideoRecordXEditingHelper.h"
#import "QRVideoRecordManager.h"
#import "QRVideoRecordViewController.h"
#import "SCRecordSession+qrRecordManager.h"

FOUNDATION_EXPORT double QRVideoRecordVersionNumber;
FOUNDATION_EXPORT const unsigned char QRVideoRecordVersionString[];

