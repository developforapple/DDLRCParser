//
//  DDAudioLRCParser.h
//  JuYouQu
//
//  Created by Normal on 16/2/19.
//  Copyright © 2016年 Bo Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DDAudioLRC;
@class DDAudioLRCUnit;

@interface DDAudioLRCParser : NSObject
+ (nullable DDAudioLRC *)parserLRCText:(NSString *)lrc;
@end

FOUNDATION_EXTERN const NSString *kDDLRCMetadataKeyTI;//歌曲名
FOUNDATION_EXTERN const NSString *kDDLRCMetadataKeyAR;//歌手名
FOUNDATION_EXTERN const NSString *kDDLRCMetadataKeyAL;//专辑
FOUNDATION_EXTERN const NSString *kDDLRCMetadataKeyBY;//编辑者
FOUNDATION_EXTERN const NSString *kDDLRCMetadataKeyOFFSET;//补偿
FOUNDATION_EXTERN const NSString *kDDLRCMetadataKeyTIME;//时长

@interface DDAudioLRC : NSObject
@property (nullable, strong, nonatomic) NSString *originLRCText;
@property (nullable, strong, nonatomic) NSArray<DDAudioLRCUnit *> *units;

// 歌词上附带的一些歌曲数据。根据 keys 取数据，数据是否存在由歌词决定。
- (void)setMetadata:(nullable id)value forKey:(NSString *)key;
- (nullable id)metadataForKey:(NSString *)key;

// 根据时间返回相应歌词所在行数
- (NSRange)linesAtTimeSecondFrom:(NSTimeInterval)from to:(NSTimeInterval)end;
- (NSUInteger)lineAtTimeSecond:(NSTimeInterval)sec;

// 根据时间返回相应的歌词
- (nullable NSArray<DDAudioLRCUnit *> *)LRCUnitsAtTimeSecondFrom:(NSTimeInterval)from to:(NSTimeInterval)end;
- (nullable DDAudioLRCUnit *)LRCUnitAtTimeSecond:(NSTimeInterval)sec;

// 返回歌词行数对应的歌词内容
- (nullable NSArray<DDAudioLRCUnit *> *)LRCUnitsAtLines:(NSRange)range;
- (nullable DDAudioLRCUnit *)LRCUnitAtLine:(NSUInteger)line;
@end

@interface DDAudioLRCUnit : NSObject
@property (nullable, strong, nonatomic) NSString *secString;
@property (assign, readonly, nonatomic) NSTimeInterval sec; // 起始时间
@property (assign, readonly, nonatomic) NSTimeInterval end; // 结束时间 也就是下一个的起始时间
@property (nullable, strong, nonatomic) NSString *lrc;

- (void)configSecString:(NSString *)secString andIsEnd:(BOOL)isend;
@end

NS_ASSUME_NONNULL_END
