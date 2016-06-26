//
//  ViewController.m
//  多线程
//
//  Created by Iracle Zhang on 6/15/16.
//  Copyright © 2016 Iracle. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UILabel *displayLabel;
@property (nonatomic) BOOL isAnimating;

@end

@implementation ViewController {
    NSOperationQueue *operationQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化队列
    operationQueue = [[NSOperationQueue alloc] init];
    
    self.displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 150, 30)];
    self.displayLabel.textAlignment = NSTextAlignmentCenter;
    self.displayLabel.text = @"hello world";
    [self.view addSubview:self.displayLabel];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.bounds = CGRectMake(0, 0, 30, 30);
    self.indicatorView.center = CGPointMake(180, 250);
    self.indicatorView.hidesWhenStopped = YES;
    [self.view addSubview:self.indicatorView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(110 , 180, 120, 30);
    [button setTitle:@"start task" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];


}

- (void)buttonTaped:(UIButton *)sender {
    if (_isAnimating) {
        return;
    }
    _isAnimating = YES;
    
    self.displayLabel.text = @"tasking....";
    [self.indicatorView startAnimating];
    /*
    //主线程中执行
    [self task];
     */
    
    /*
    //1.perform 方法把一段代码放到后台线程中执行
    [self performSelectorInBackground:@selector(task) withObject:nil];
     */
    
    /*
    //2.NSThread
//    [NSThread detachNewThreadSelector:@selector(task) toTarget:self withObject:nil];
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(task) object:nil];
    
    [thread start];
     */
    
    /*
    //3.NSOperation, NSOperationQueue
    NSOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task) object:nil];
    //添加到队列执行
    [operationQueue addOperation:operation];
     */
    
    //GCD: Grand Central Dispatch
    //全局队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //主队列
    dispatch_queue_t mainQueque = dispatch_get_main_queue();
    
    //把代码提交到队列中异步执行
    dispatch_async(globalQueue, ^{
        
        NSDate *beginDate = [NSDate date];
        //指定当前线程休眠时间
        [NSThread sleepForTimeInterval:3];
        NSDate *endDate = [NSDate date];
        
        NSTimeInterval duration = [endDate timeIntervalSinceDate:beginDate];
        NSLog(@"休眠时间：%.0f", duration);
        
        //后台线程执行完毕后，在主线程中更新UI
        dispatch_async(mainQueque, ^{
            [self.indicatorView stopAnimating];
            self.displayLabel.text = @"finish tast";
            _isAnimating = NO;
        });
    });
    
    
    
    
    
    
    
    
    
    
    
    
}
//模拟耗时操作
- (void)task{
    NSDate *beginDate = [NSDate date];
    //指定当前线程休眠时间
    [NSThread sleepForTimeInterval:3];
    NSDate *endDate = [NSDate date];
    
    NSTimeInterval duration = [endDate timeIntervalSinceDate:beginDate];
     NSLog(@"休眠时间：%.0f", duration);
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
    
}

- (void)updateUI {
    
    [self.indicatorView stopAnimating];
    self.displayLabel.text = @"finish tast";
    _isAnimating = NO;
}


@end













