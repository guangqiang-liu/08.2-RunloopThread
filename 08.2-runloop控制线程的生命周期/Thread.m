//
//  Thread.m
//  08.2-runloop控制线程的生命周期
//
//  Created by 刘光强 on 2020/2/10.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import "Thread.h"

@implementation Thread

- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end
