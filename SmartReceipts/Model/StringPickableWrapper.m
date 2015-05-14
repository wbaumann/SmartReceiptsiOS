//
//  StringPickableWrapper.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 14/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "StringPickableWrapper.h"

@interface StringPickableWrapper ()

@property (nonatomic, copy) NSString *wrapped;

@end

@implementation StringPickableWrapper

+ (NSArray *)wrapValues:(NSArray *)values {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:values.count];
    for (NSString *value in values) {
        StringPickableWrapper *wrapper = [[StringPickableWrapper alloc] init];
        [wrapper setWrapped:value];
        [result addObject:wrapper];
    }
    return [NSArray arrayWithArray:result];
}

- (NSString *)presentedValue {
    return self.wrapped;
}

+ (StringPickableWrapper *)wrapValue:(NSString *)value {
    StringPickableWrapper *wrapper = [[StringPickableWrapper alloc] init];
    [wrapper setWrapped:value];
    return wrapper;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    StringPickableWrapper *wrapper = other;

    return [self.wrapped isEqualToString:wrapper.wrapped];
}

- (NSUInteger)hash {
    return [self.wrapped hash];
}

@end
