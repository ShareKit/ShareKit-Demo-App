//
//  PDKInterest.m
//  Pods
//
//  Created by Ricky Cancro on 3/17/15.
//
//

#import "PDKInterest.h"

@implementation PDKInterest

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _name = dictionary[@"name"];
        _identifier = dictionary[@"id"];
    }
    return self;
}

+ (instancetype)interestFromDictionary:(NSDictionary *)dictionary
{
    return [[PDKInterest alloc] initWithDictionary:dictionary];
}

@end
