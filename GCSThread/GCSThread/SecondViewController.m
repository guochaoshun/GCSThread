//
//  SecondViewController.m
//  GCSThread
//
//  Created by 郭朝顺 on 2022/8/20.
//

#import "SecondViewController.h"
#import "GCSThread.h"


@interface SecondViewController ()

@property (nonatomic, strong) GCSThread *thread;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GCSThread *thread = [[GCSThread alloc] initWithName:@"com.gcs.SecondViewController" mode:NSDefaultRunLoopMode];
    [thread start];
    self.thread = thread;

    // 任务1 丢给线程去做
    [self performSelector:@selector(task1) onThread:thread.nsThread withObject:nil waitUntilDone:NO];

    // 任务2 丢给线程去做
    [self performSelector:@selector(task2) onThread:thread.nsThread withObject:nil waitUntilDone:NO];
}

- (void)task1 {
    NSLog(@"%s 开始",__func__);
    sleep(4);
    NSLog(@"%s 结束",__func__);

}

- (void)task2 {
    NSLog(@"%s 开始",__func__);
    sleep(10);
    NSLog(@"%s 结束",__func__);
}


- (void)dealloc {
//    [self.thread stop];
}


@end
