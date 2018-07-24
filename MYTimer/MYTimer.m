//
//  MYTimer.m
//  MYTimer
//
//  Created by dingbinbin on 2018/7/20.
//  Copyright © 2018年 dingbinbin. All rights reserved.
//

#import "MYTimer.h"

@implementation MYTimer

static NSMutableDictionary *timers_;
dispatch_semaphore_t semaphore_;

+ (void)initialize {
    
    // 只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers_ = [NSMutableDictionary dictionary];
        semaphore_ = dispatch_semaphore_create(1);
    });
}

+ (NSString *)gcdTimerWithStart:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async block:(void (^)(void))block {
    
    if (!block || start < 0 || (interval <= 0 && repeats == YES)) {
        return nil;
    }
    
    // 异步获取全局队列，同步获取主队列
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    
    // 创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置开始时间和时间间隔
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, start * NSEC_PER_SEC, interval * NSEC_PER_SEC);
    
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    NSString *name = [NSString stringWithFormat:@"%zd", timers_.count];
    timers_[name] = timer;
    dispatch_semaphore_signal(semaphore_);
    
    // 设置回调
    dispatch_source_set_event_handler(timer, ^{
        block();
        
        // 不需要重复进行，直接取消定时器
        if (!repeats) {
            [self cancelTimer:name];
        }
    });
    
    // 启动定时器
    dispatch_resume(timer);
    
    return name;
}

+ (NSString *)gcdTimerWithStart:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async target:(id)target selector:(SEL)selector
{
    if (!target || !selector) return nil;
    
    return [self gcdTimerWithStart:start interval:interval repeats:repeats async:async block:^{
        if ([target respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:selector];
#pragma clang diagnostic pop
        }
    }];

}

+ (void)cancelTimer:(NSString *)name {
    if (name.length == 0) {
        return;
    }
    
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = timers_[name];
    if (timer) {
        dispatch_source_cancel(timer);
        [timers_ removeObjectForKey:name];
    }
    dispatch_semaphore_signal(semaphore_);
}

@end
