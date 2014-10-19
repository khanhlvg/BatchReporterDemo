//
//  KBLogReporterService.m
//  BatchReporterDemo
//
//  Created by Ko Bluewater on 10/19/14.
//  Copyright (c) 2014 Ko Bluewater. All rights reserved.
//

#import "KBLogReporterService.h"
#import "KBLogReporterFetcher.h"

@implementation KBLogReporterService
{
    NSMutableDictionary *_unsentLogDict;
    BOOL _isSending;
}

static const float kLogSentIntervalInSecond = 10.0f;

#pragma mark - Singleton

+ (instancetype)sharedInstance
{
    static KBLogReporterService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _isSending = NO;
    
    [self loadLogFromStorage];
    [self setupPeriodicalLogSender];
    
    return self;
}

#pragma mark - Storage Plist methods

+ (NSString *)pathOfStoragePlist
{
    NSURL *directoryPath= [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                     inDomains:NSUserDomainMask] lastObject];
    return [directoryPath.path stringByAppendingPathComponent:@"unsend.plist"];
}

- (void)loadLogFromStorage
{
    _unsentLogDict = [NSMutableDictionary dictionary];

    NSMutableDictionary *unsentLogForStorage = [NSMutableDictionary dictionaryWithContentsOfFile:[self.class pathOfStoragePlist]];
    NSEnumerator *enumerator = [unsentLogForStorage keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        NSData *storageObj = [unsentLogForStorage objectForKey:key];
        KBLogEntity *entity = [NSKeyedUnarchiver unarchiveObjectWithData:storageObj];
        if (entity) {
            [_unsentLogDict setObject:entity forKey:key];
        }
    }
    NSLog(@"Loaded %zd stored log items. ",_unsentLogDict.count);
}

- (void)saveLogToStorage
{
    NSMutableDictionary *unsentLogForStorage = [NSMutableDictionary dictionary];
    NSEnumerator *enumerator = [_unsentLogDict keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        KBLogEntity *entity = [_unsentLogDict objectForKey:key];
        NSData *storageObj = [NSKeyedArchiver archivedDataWithRootObject:entity];
        [unsentLogForStorage setValue:storageObj forKey:key];
    }
    
    BOOL result = [unsentLogForStorage writeToFile:[self.class pathOfStoragePlist] atomically:YES];
    if (!result) {
        NSLog(@"ERROR: Failed to write to file!");
    }
}

- (NSArray *)sendQueueOfLogEntity
{
    return _unsentLogDict.allValues;
}

- (void)removeSentLogEntity:(NSArray *)sentLogEntityList
{
    @synchronized(self)
    {
        for (KBLogEntity *entity in sentLogEntityList) {
            [_unsentLogDict removeObjectForKey:entity.uniqueIdentifier];
        }
        [self saveLogToStorage];
    }
}

#pragma mark - Log Reporter Methods
- (void)sendLog:(KBLogEntity *)logEntity
{
    @synchronized(self)
    {
        [_unsentLogDict setObject:logEntity forKey:logEntity.uniqueIdentifier];
        [self saveLogToStorage];
    }
}

- (void)startSendingProcess
{
    NSArray *sendQueue = self.sendQueueOfLogEntity;
    if ([sendQueue count] == 0) {
        return;
    }
    
    _isSending = YES;
    KBLogReporterFetcher *fetcher = [KBLogReporterFetcher newFetcherWithLogEntityList:sendQueue];
    [fetcher startFetcherWithSuccessHandler:^{
        [self removeSentLogEntity:sendQueue];
        _isSending = NO;
    } failureHandler:^{
        _isSending = NO;
    }];
    
}

- (BOOL)isSending
{
    return _isSending;
}

#pragma mark - methods to send log periodically
- (void)setupPeriodicalLogSender
{
    [NSTimer scheduledTimerWithTimeInterval:kLogSentIntervalInSecond
                                     target:self
                                   selector:@selector(startSendingProcess)
                                   userInfo:nil
                                    repeats:YES];
}

@end
