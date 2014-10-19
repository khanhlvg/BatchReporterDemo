//
//  KBLogReporterFetcher.h
//  BatchReporterDemo
//
//  Created by Ko Bluewater on 10/19/14.
//  Copyright (c) 2014 Ko Bluewater. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KBLogEntity;

@interface KBLogReporterFetcher : NSObject

+ (instancetype) newFetcherWithLogEntity:(KBLogEntity *)logEntity;

+ (instancetype) newFetcherWithLogEntityList:(NSArray *)logEntityList;

- (void)startFetcherWithSuccessHandler:(void (^)(void))successHandler failureHandler:(void (^)(void))failureHandler;

@end
