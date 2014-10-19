//
//  KBLogEntity.h
//  BatchReporterDemo
//
//  Created by Ko Bluewater on 10/19/14.
//  Copyright (c) 2014 Ko Bluewater. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBLogEntity : NSObject <NSCoding>

/*!
 @abstract ログが発生する時刻
 */
@property (strong,nonatomic) NSDate *timeStamp;

/*!
 @abstract ログの画面ID
 */
@property (strong,nonatomic) NSString *screenID;


/*!
 @abstract Unique identifier of log entity object for use as NSDictionary key
 */
- (NSString *)uniqueIdentifier;

@end
