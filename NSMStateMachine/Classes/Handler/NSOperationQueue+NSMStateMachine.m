// NSOperationQueue+NSMStateMachine.m
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

#import "NSOperationQueue+NSMStateMachine.h"
#import "NSMMessageOperation.h"

@implementation NSOperationQueue (NSMStateMachine)

- (void)nsm_addOperationAtFrontOfQueue:(NSOperation *)op {
    NSArray *operations = self.operations;
    [operations enumerateObjectsUsingBlock:^(NSOperation* operation, NSUInteger idx, BOOL *stop) {
        if(![operation isExecuting]){
            if (operation.dependencies.count > 0) {
                [operation.dependencies enumerateObjectsUsingBlock:^(NSOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [operation removeDependency:obj];
                }];
            }
            [operation addDependency:op];
            *stop = YES;
        }
    }];
    [self addOperation:op];
}

- (void)nsm_addOperation:(NSOperation *)op {
    NSArray *operations = [self operations];
    NSInteger maxOperations = ([self maxConcurrentOperationCount] > 0) ? [self maxConcurrentOperationCount]: INT_MAX;
    NSInteger remain = [operations count] - maxOperations;
    if (remain >= 0) {
        NSOperation *operation = operations.lastObject;
        if (![operation isExecuting]) {
            [op addDependency:operation];
        }
    }
    [self addOperation:op];
}

- (void)nsm_removeOperationWithType:(NSInteger)type {
    NSArray *operations = self.operations;
    [operations enumerateObjectsUsingBlock:^(NSMMessageOperation* operation, NSUInteger idx, BOOL *stop){
        if(type == operation.message.messageType) {
            [operation cancel];
        }
    }];
}

@end
