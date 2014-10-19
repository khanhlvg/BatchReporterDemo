//
//  KBLogReporterService.h
//  BatchReporterDemo
//
//  Created by Ko Bluewater on 10/19/14.
//  Copyright (c) 2014 Ko Bluewater. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KBLogEntity.h"

@interface KBLogReporterService : NSObject

/*
 @abstract SingletonのsharedInstance
 */
+ (instancetype)sharedInstance;

/*!
 @abstract ログをバッファーに貯めて、準備が整ったタイミングで送信処理を発火する
 @param logEntity ログ内容を保持するエンティティ
 */
- (void)sendLog:(KBLogEntity *)logEntity;

/*!
 @abstract ログ送信処理の実施statusを教える
 @return 送信処理実施中：YES  送信処理実施中ではない：NO
 */
- (BOOL)isSending;

/*!
 @abstract まだ送信していない、もしくは送信が成功していないログの配列
 */
- (NSArray *)sendQueueOfLogEntity;

@end
