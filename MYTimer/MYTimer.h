//
//  MYTimer.h
//  MYTimer
//
//  Created by dingbinbin on 2018/7/20.
//  Copyright © 2018年 dingbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYTimer : NSObject

+ (NSString *)gcdTimerWithStart:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async block:(void (^)(void))block;

+ (NSString *)gcdTimerWithStart:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async target:(id)target selector:(SEL)selector;

+ (void)cancelTimer:(NSString *)name;

@end
