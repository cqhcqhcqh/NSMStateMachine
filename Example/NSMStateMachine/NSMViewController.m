// NSMViewController.m
//
// Copyright (c) 2017 NSMStateMachine
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSMViewController.h"
@import NSMStateMachine;

@interface NSMViewController ()

@end

@implementation NSMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test];
}

- (void)test {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.maxConcurrentOperationCount = 4;
    
    for (NSInteger i = 0; i < 10; i++) {
        [operationQueue nsm_addOperation:[NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"task%@ begin", @(i));
            [NSThread sleepForTimeInterval:arc4random_uniform(3)];
            //NSLog(@"task%@ end", @(i));
        }]];
    }
    
    [operationQueue nsm_addOperationAtFrontOfQueue:[NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"task%@ begin", @(10));
        [NSThread sleepForTimeInterval:arc4random_uniform(4)];
        //NSLog(@"task%@ end", @(10));
    }]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
