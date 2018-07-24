//
//  ViewController.m
//  MYTimer
//
//  Created by dingbinbin on 2018/7/20.
//  Copyright © 2018年 dingbinbin. All rights reserved.
//

#import "ViewController.h"
#import "MYTimer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [MYTimer gcdTimerWithStart:1.0f interval:1.0f repeats:YES async:NO block:^{
        NSLog(@"timer log");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
