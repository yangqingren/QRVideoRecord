
//
//  SCRecordSession+qrRecordManager.m
//  LBCategory
//  pod lib create QRVideoRecord
//  pod lib lint --allow-warnings
//  pod trunk push --allow-warnings --use-libraries
//  Created by 杨庆人 on 2018/11/19.
//

#import "SCRecordSession+qrRecordManager.h"

NSString *const kRecordSessions = @"kRecordSessions";

@implementation SCRecordSession (qrRecordManager)
+ (void)qr_modifyMetadatas:(void(^)(NSMutableArray *metadatas))block {
    NSMutableArray *metadatas = [[self.class qr_savedRecordSessions] mutableCopy];
    if (metadatas == nil) {
        metadatas = [NSMutableArray new];
    }
    block(metadatas);
    [[NSUserDefaults standardUserDefaults] setObject:metadatas forKey:kRecordSessions];
}

- (void)qr_saveRecordSession {
    [self.class qr_modifyMetadatas:^(NSMutableArray *metadatas) {
        NSInteger insertIndex = -1;
        for (int i = 0; i < metadatas.count; i++) {
            NSDictionary *otherRecordSessionMetadata = [metadatas objectAtIndex:i];
            if ([otherRecordSessionMetadata[SCRecordSessionIdentifierKey] isEqualToString:self.identifier]) {
                insertIndex = i;
                break;
            }
        }
        NSDictionary *metadata = self.dictionaryRepresentation;
        if (insertIndex == -1) {
            [metadatas addObject:metadata];
        } else {
            [metadatas replaceObjectAtIndex:insertIndex withObject:metadata];
        }
    }];
}

- (void)qr_removeRecordSession {
    [self.class qr_modifyMetadatas:^(NSMutableArray *metadatas) {
        for (int i = 0; i < metadatas.count; i++) {
            NSDictionary *otherRecordSessionMetadata = [metadatas objectAtIndex:i];
            if ([otherRecordSessionMetadata[SCRecordSessionIdentifierKey] isEqualToString:self.identifier]) {
                i--;
                [metadatas removeObjectAtIndex:i];
                break;
            }
        }
    }];
}

- (BOOL)qr_isSaved {
    NSArray *sessions = [self.class qr_savedRecordSessions];
    for (NSDictionary *session in sessions) {
        if ([session[SCRecordSessionIdentifierKey] isEqualToString:self.identifier]) {
            return YES;
        }
    }
    return NO;
}

- (void)qr_removeRecordSessionAtIndex:(NSInteger)index {
    [self.class qr_modifyMetadatas:^(NSMutableArray *metadatas) {
        [metadatas removeObjectAtIndex:index];
    }];
}

+ (NSArray *)qr_savedRecordSessions {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRecordSessions];
}

@end
