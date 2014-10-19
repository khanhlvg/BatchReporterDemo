//
//  KBLogReporterFetcher.m
//  BatchReporterDemo
//
//  Created by Ko Bluewater on 10/19/14.
//  Copyright (c) 2014 Ko Bluewater. All rights reserved.
//

#import "KBLogReporterFetcher.h"
#import "KBLogEntity.h"

@implementation KBLogReporterFetcher
{
    NSArray *_logEntityList;
}

+ (instancetype)newFetcherWithLogEntity:(KBLogEntity *)logEntity
{
    NSArray *logEntityList = [NSArray arrayWithObject:logEntity];
    KBLogReporterFetcher *instanceVar = [[self alloc] initWithLogEntityList:logEntityList];
    return instanceVar;
}

+ (instancetype)newFetcherWithLogEntityList:(NSArray *)logEntityList
{
    KBLogReporterFetcher *instanceVar = [[self alloc] initWithLogEntityList:logEntityList];
    return instanceVar;
}

- (instancetype)initWithLogEntityList:(NSArray *)logEntityList;
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    for (id item in logEntityList) {
        if (![[item class] isSubclassOfClass:[KBLogEntity class]]) {
            return nil;
        }
    }
    
    _logEntityList = [logEntityList copy];
    
    return self;
}

- (void)startFetcherWithSuccessHandler:(void (^)(void))successHandler failureHandler:(void (^)(void))failureHandler
{
    NSLog(@"\n>Trying to send %zd log entities", _logEntityList.count);
    
    BOOL isSuccess = arc4random_uniform(10) > 5;
    
    
    if (isSuccess) {
        for (KBLogEntity *entity in _logEntityList) {
            NSLog(@">>Send log entity: %@", [entity uniqueIdentifier]);
        }
        successHandler();
    } else {
        NSLog(@">>Failed to send!");
    }
    
}

@end
