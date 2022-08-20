//
//  GCSThread.m
//  GCSThread
//
//  Created by 郭朝顺 on 2022/8/20.
//

#import "GCSThread.h"

@interface GCSThread ()
/// 运行的线程
@property (nonatomic, strong) NSThread *realThread;
/// runloop源
@property (nonatomic, strong) NSPort *localPort;
/// runloop运行的mode
@property (nonatomic, copy) NSRunLoopMode runloopMode;
/// 是否运行中
@property (nonatomic, assign) BOOL executing;

@end

@implementation GCSThread

- (instancetype)init {
    return [self initWithName:@"com.gcs.defaultName" mode:NSDefaultRunLoopMode];
}

- (instancetype)initWithName:(NSString *)name mode:(NSRunLoopMode)mode {
    self = [super init];
    if (self) {
        _name = name;
        _runloopMode = mode;
    }
    return self;
}

/// 创建并开启线程
- (void)start {
    if (!self.realThread) {
        self.realThread = [[NSThread alloc] initWithTarget:self selector:@selector(p_thread_entry) object:nil];
        self.realThread.name = self.name;
        self.localPort = [NSMachPort port];
        [self.realThread start];
        self.executing = YES;
    }
}

/// 停止线程并退出runloop
- (void)stop {
    if (self.realThread) {
        self.executing = NO;
        [self performSelector:@selector(p_stopThread) onThread:self.realThread withObject:nil waitUntilDone:NO];
    }
}

/// 返回 NSThread * 对象
- (NSThread *)nsThread {
    return self.realThread;
}

#pragma mark - Private

- (void)p_thread_entry {
    @autoreleasepool {
        NSRunLoopMode runloopMode = self.runloopMode;
        NSThread *currentThread = [NSThread currentThread];
        NSLog(@"[ULThread]：%@ start runloop", currentThread.name);
        // 引申：基于runloop的特性，子线程默认不开启，需要人为开启runloop，且：runloop的运行则依赖于Source、Timer、Observer，若都无，则会自动退出
        [[NSRunLoop currentRunLoop] addPort:self.localPort forMode:runloopMode];
        // runloop run
        BOOL isCancelled = [currentThread isCancelled];
        while (!isCancelled && [[NSRunLoop currentRunLoop] runMode:runloopMode beforeDate:[NSDate distantFuture]]) {
            isCancelled = [currentThread isCancelled];
        }
        // runloop stop
        NSLog(@"[ULThread]：%@ stop runloop", currentThread.name);
    }
}
- (void)p_stopThread {
    // 将线程标记为canceled
    [self.realThread cancel];
    self.realThread = nil;
    // 移除runloop源
    [self.localPort invalidate];
    NSRunLoopMode runloopMode = self.runloopMode;
    [[NSRunLoop currentRunLoop] removePort:self.localPort forMode:runloopMode];
    self.localPort = nil;
    // 停止Runloop
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}
@end
