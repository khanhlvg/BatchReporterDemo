//
//  KBLogEntity.m
//  BatchReporterDemo
//
//  Created by Ko Bluewater on 10/19/14.
//  Copyright (c) 2014 Ko Bluewater. All rights reserved.
//

#import "KBLogEntity.h"
#import <objc/runtime.h>

@implementation KBLogEntity

#pragma mark - NSCoding protocol methods - lazy Coder
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self loopOverPropertyWithHandler:^(NSString *propertyName) {
        id value = [aDecoder decodeObjectForKey:propertyName];
        [self setValue:value forKey:propertyName];
    }];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self loopOverPropertyWithHandler:^(NSString *propertyName) {
        id value = [self valueForKey:propertyName];
        [aCoder encodeObject:value forKey:propertyName];
    }];
}

- (void)loopOverPropertyWithHandler:(void (^) (NSString *))handler
{
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
        
        handler(propertyName);
    }
    free(propertyArray);
}

- (NSString *)uniqueIdentifier
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [NSString stringWithFormat:@"%@:%@", self.screenID, [dateFormater stringFromDate:self.timeStamp]];
}

@end
