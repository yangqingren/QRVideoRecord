//
//  SCRecordSession+qrRecordManager.h
//  LBCategory
//
//  Created by 杨庆人 on 2018/11/19.
//

#import <SCRecorder/SCRecordSession.h>

@interface SCRecordSession (qrRecordManager)

- (void)qr_saveRecordSession;

- (void)qr_removeRecordSession;

- (BOOL)qr_isSaved;

- (void)qr_removeRecordSessionAtIndex:(NSInteger)index;

+ (NSArray *)qr_savedRecordSessions;

@end

