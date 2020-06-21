//
//  ViewController.m
//  08.2-runloop控制线程的生命周期
//
//  Created by 刘光强 on 2020/2/10.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import "ViewController.h"
#import "Thread.h"

@interface ViewController ()

@property (nonatomic, strong) Thread *thread;
@property (nonatomic, assign, getter=isStoped) BOOL stoped;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.stoped = NO;
    
    __weak typeof(self) weakSelf = self;
    
    // 创建线程
    self.thread = [[Thread alloc] initWithBlock:^{
        NSLog(@"---begin---%@", [NSThread currentThread]);
        
        // 给runloop添加Item，也就是添加一个Source(port属于source1)
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        
        while (weakSelf && !weakSelf.isStoped) {
            // 使用runMode方法替代run方法来启动runloop
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
                
        NSLog(@"---end---%@",[NSThread currentThread]);
    }];
    
    // 启动线程
    [self.thread start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.thread) return;
    
    // performSelector:函数的作用就是在指定的线程上执行任务
    [self performSelector:@selector(doTask) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)doTask {
    NSLog(@"开始执行线程分配的任务");
}

- (void)stopRunLoop {
    self.stoped = YES;
    
    // 此函数的作用是用来停止指定的runloop
    CFRunLoopStop(CFRunLoopGetCurrent());
    
    NSLog(@"------%@",[NSThread currentThread]);
    
    self.thread = nil;
}

- (void)clear {
    if (!self.thread) return;
    
    // 我们在控制器销毁的函数中给self.thread线程添加一个任务，用来停止runloop
    [self performSelector:@selector(stopRunLoop) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    
    // 控制器即将销毁时，停止runloop
    [self clear];
}
@end
