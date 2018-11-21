# QRVideoRecord

[![CI Status](https://img.shields.io/travis/yangqingren/QRVideoRecord.svg?style=flat)](https://travis-ci.org/yangqingren/QRVideoRecord)
[![Version](https://img.shields.io/cocoapods/v/QRVideoRecord.svg?style=flat)](https://cocoapods.org/pods/QRVideoRecord)
[![License](https://img.shields.io/cocoapods/l/QRVideoRecord.svg?style=flat)](https://cocoapods.org/pods/QRVideoRecord)
[![Platform](https://img.shields.io/cocoapods/p/QRVideoRecord.svg?style=flat)](https://cocoapods.org/pods/QRVideoRecord)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

    Basic usage
     QRVideoRecordViewController *vc = [[QRVideoRecordViewController alloc] init];
     vc.delegate = (id <QRVideoRecordDelegate>)self;
     [self presentViewController:vc animated:YES completion:nil];
     
    /**
     * video record result

     * @param fileURL video local url
     * @param filePath video local path
     * @param fileName video name
     * fileURL will be triggered after video recording is finished.
     */
     - (void)finishVideoRecordCapture:(NSURL *)fileURL filePath:(NSString *)filePath fileName:(NSString *)fileName;
     
     If you want to expand...
     Please use inherit
     #import <QRVideoRecord/QRVideoRecordViewController.h>
     @interface LBQRViewController : QRVideoRecordViewController
     @end
     
     other usage
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
     
     other expand
    /**
     * flash lamp
     * set this property so that you can set up and turn off the astigmatism conveniently.
     * expand property
     */
    @property (nonatomic, assign) AVCaptureFlashMode flashMode;

    /**
     * camera direction
     * set this property So that you can easily change the front and rear cameras.
     * expand property, nullable property
     */
    @property (nonatomic, assign) AVCaptureDevicePosition devicePosition;


    /**
     * video record result call.
     * you can do your video recording after completion, such as jump page.
     * The extension must first call the parent class method. use super doNextWhenVideoSavedSuccess will be call fileURL completion
     */
    - (void)doNextWhenVideoSavedSuccess;
     

## Installation

QRVideoRecord is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'QRVideoRecord'
```

## Author

yangqingren, 564008993@qq.com

## License

QRVideoRecord is available under the MIT license. See the LICENSE file for more info.
