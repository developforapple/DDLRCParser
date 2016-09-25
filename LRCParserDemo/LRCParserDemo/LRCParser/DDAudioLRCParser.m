//
//  DDAudioLRCParser.m
//  JuYouQu
//
//  Created by Normal on 16/2/19.
//  Copyright © 2016年 Bo Wang. All rights reserved.
//

#import "DDAudioLRCParser.h"

@implementation DDAudioLRCParser

+ (DDAudioLRC *)parserLRCText:(NSString *)lrc
{
    return [self parser:lrc];
}

+ (DDAudioLRC *)parser:(NSString *)lrc
{
    if (!lrc || lrc.length == 0) {
        return nil;
    }
    
    DDAudioLRC *tmp = [DDAudioLRC new];
    
    NSArray *tags = @[kDDLRCMetadataKeyTI,
                      kDDLRCMetadataKeyAR,
                      kDDLRCMetadataKeyAL,
                      kDDLRCMetadataKeyBY,
                      kDDLRCMetadataKeyOFFSET];
    
    NSString * reg = @"(\\[\\d{0,2}:\\d{0,2}([.|:]\\d{0,2})?\\])";
    NSRegularExpression * eachTimeReg = [NSRegularExpression regularExpressionWithPattern:reg options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString *reg2 = @"(\\[\\d{0,2}:\\d{0,2}([.|:]\\d{0,2})?\\])+";
    NSRegularExpression * allTimeReg = [NSRegularExpression regularExpressionWithPattern:reg2 options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSMutableArray *units = [NSMutableArray array];
    NSArray *lines = [lrc componentsSeparatedByString:@"\n"];
    
    NSString *sec;
    NSArray *matches;
    NSString *modifyString;
    
    
    for (NSString *aLine in lines) {
        if (aLine.length <= 1) {
            continue;
        }
        BOOL isATag = NO;
        
        //歌曲信息
        for (NSString *tag in tags) {
            if (![tmp metadataForKey:tag]) {
                NSString *prefix = [NSString stringWithFormat:@"[%@:",tag];
                if ([aLine hasPrefix:prefix] && [aLine hasSuffix:@"]"]) {
                    NSUInteger loc = prefix.length;
                    NSUInteger len = aLine.length - loc - 1;
                    NSString *info = [aLine substringWithRange:NSMakeRange(loc, len)];
                    [tmp setMetadata:info forKey:tag];
                    isATag = YES;
                    break;
                }
            }
        }
        
        if (isATag) {
            continue;
        }
        
        // 歌词时间信息
        matches = [eachTimeReg matchesInString:aLine options:0 range:NSMakeRange(0, aLine.length)];
        
        /**< 歌词*/
        modifyString = [allTimeReg  stringByReplacingMatchesInString:aLine options:0 range:NSMakeRange(0, aLine.length) withTemplate:@""];
        
        for (NSTextCheckingResult *result in matches) {
            if (result.range.location == NSNotFound) {
                continue;
            }
            sec = [aLine substringWithRange:result.range];
            sec = [sec stringByReplacingOccurrencesOfString:@"[" withString:@""];
            sec = [sec stringByReplacingOccurrencesOfString:@"]" withString:@""];
            
            DDAudioLRCUnit *unit = [DDAudioLRCUnit new];
            unit.secString = sec;
            unit.lrc = modifyString;
            [units addObject:unit];
        }
    }
    
    tmp.units = [self sortedLRCUnits:units];
    tmp.originLRCText = lrc;
    return tmp;
}

+ (NSArray<DDAudioLRCUnit *> *)sortedLRCUnits:(NSArray<DDAudioLRCUnit *> *)units
{
    //按时间排序
    NSArray *sorted = [units sortedArrayUsingComparator:^NSComparisonResult(DDAudioLRCUnit *obj1, DDAudioLRCUnit *obj2) {
        if (obj1.sec < obj2.sec) {
            return NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }
    }];
    return sorted;
}

@end

NSString *kDDLRCMetadataKeyTI = @"ti";
NSString *kDDLRCMetadataKeyAR = @"ar";
NSString *kDDLRCMetadataKeyAL = @"al";
NSString *kDDLRCMetadataKeyBY = @"by";
NSString *kDDLRCMetadataKeyOFFSET = @"offset";
NSString *kDDLRCMetadataKeyTIME = @"t_time";

@implementation DDAudioLRC
{
    NSMutableDictionary *_medatata;
    NSNumber *_offset;
}

- (void)setMetadata:(id)value forKey:(NSString *)key
{
    if (!_medatata) {
        _medatata = [NSMutableDictionary dictionary];
    }
    if (value && key) {
        _medatata[key] = value;
    }
}

- (id)metadataForKey:(NSString *)key
{
    return _medatata[key];
}

- (float)lrcOffset
{
    if (!_offset) {
        _offset = [self metadataForKey:kDDLRCMetadataKeyOFFSET];
    }
    return _offset.floatValue;
}

- (NSRange)linesAtTimeSecondFrom:(NSTimeInterval)from to:(NSTimeInterval)to
{
    if (from > to) {
        return NSMakeRange(NSNotFound, 0);
    }
    
    NSTimeInterval start = from + [self lrcOffset];
    NSTimeInterval end = to + [self lrcOffset];
    
    NSMutableIndexSet *indexSets = [NSMutableIndexSet indexSet];
    [self.units enumerateObjectsUsingBlock:^(DDAudioLRCUnit *obj, NSUInteger idx, BOOL *stop) {
        if (obj.sec >= start && obj.sec <= end) {
            [indexSets addIndex:idx];
        }
        if (obj.sec > end) {
            *stop = YES;
        }
    }];
    
    NSUInteger firstIndex = [indexSets firstIndex];
    NSUInteger lastIndex = [indexSets lastIndex];
    if (firstIndex > 0) {
        firstIndex --;
    }
    
    NSUInteger numberOfLines = lastIndex - firstIndex + 1;
    NSRange range = NSMakeRange(firstIndex, numberOfLines);
    return range;
}

- (NSUInteger)lineAtTimeSecond:(NSTimeInterval)sec
{
    NSRange range = [self linesAtTimeSecondFrom:sec to:sec+0.001];
    return range.location;
}

- (NSArray<DDAudioLRCUnit *> *)LRCUnitsAtTimeSecondFrom:(NSTimeInterval)from to:(NSTimeInterval)end
{
    NSRange range = [self linesAtTimeSecondFrom:from to:end];
    return [self LRCUnitsAtLines:range];
}

- (DDAudioLRCUnit *)LRCUnitAtTimeSecond:(NSTimeInterval)sec
{
    return [[self LRCUnitsAtTimeSecondFrom:sec to:sec+0.001] firstObject];
}

- (NSArray<DDAudioLRCUnit *> *)LRCUnitsAtLines:(NSRange)range
{
    return [self safeSubarrayWithRange:range inArray:self.units];
}

- (DDAudioLRCUnit *)LRCUnitAtLine:(NSUInteger)line
{
    return [[self LRCUnitsAtLines:NSMakeRange(line, 1)] firstObject];
}

/**
 *  @brief 安全的取子数组。根据范围尽量取到合适的子数组，范围越界时也取。
 *
 *  @param range 子数组范围
 *  @param array 父数组
 *
 *  @return 子数组
 */
- (NSArray *)safeSubarrayWithRange:(NSRange)range inArray:(NSArray *)array
{
    if (range.location == NSNotFound || !array || array.count == 0) {
        return nil;
    }
    
    NSUInteger count = array.count;
    NSUInteger loc = range.location;
    NSUInteger len = range.length;
    
    if (loc >= count) {
        return nil;
    }
    if (count - loc < len) { //防止整形溢出
        len = count - loc;
    }
    NSRange safeRange = NSMakeRange(loc, len);
    return [array subarrayWithRange:safeRange];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@\nmetedata:%@\n%@",[super description],_medatata,self.units];
}

@end

@implementation DDAudioLRCUnit

- (void)setSecString:(NSString *)secString
{
    _secString = secString;
    
    NSInteger m = 0;   //分
    NSInteger s = 0;   //秒
    NSInteger ms = 0;  //毫秒
    
    NSArray * components = [secString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":."]];
    if (components && components.count >= 2) {
        m = [components[0] integerValue];
        s = [components[1] integerValue];
        if (components.count == 3) {
            ms = [components[2] integerValue];
        }else{
            ms = 0;
        }
    }else{
        s = INT_MAX;
    }
    
    NSTimeInterval time = m*60 + s + ms*0.001;
    self->_sec = time;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, timeSecond:%.0f , LRC:%@",[super description],self.sec,self.lrc];
}
@end
