//
//  GCSThread.h
//  GCSThread
//
//  Created by 郭朝顺 on 2022/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 提供一个跟Runloop绑定的子线程
/// 初始化：通过初始化指定线程名字，与runloop运行的mode来返回 ULThread
/// @nsThread 当线程开启后，通过使用NSThread对象来完成任务调度
/// @using 若我们需要开启一个单独的子线程去调度一些任务，可以使用此类，通过调用 - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait，将thr传入 -[ULThread nsThread] 完成任务派发到子线程

@interface GCSThread : NSObject
/// 线程名
@property (nonatomic, copy, readonly) NSString *name;
/// runloop mode
@property (nonatomic, copy, readonly) NSRunLoopMode runloopMode;
/// 是否运行中
@property (nonatomic, assign, readonly) BOOL executing;
/// 初始化方法
- (instancetype)initWithName:(NSString *)name mode:(NSRunLoopMode)mode;
/// 创建并开启线程
- (void)start;
/// 停止线程并退出runloop
- (void)stop;
/// 获取NSThread对象
- (NSThread *)nsThread;

@end

NS_ASSUME_NONNULL_END
