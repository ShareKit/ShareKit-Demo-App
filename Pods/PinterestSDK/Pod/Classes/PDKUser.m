//  Copyright (c) 2015 Pinterest. All rights reserved.
//  Created by Ricky Cancro on 1/28/15.

#import "PDKUser.h"

#import "PDKImageInfo.h"

@interface PDKUser()
@property (nonatomic, copy, readwrite) NSString *firstName;
@property (nonatomic, copy, readwrite) NSString *lastName;
@property (nonatomic, copy, readwrite) NSString *username;
@property (nonatomic, copy, readwrite) NSString *biography;

@property (nonatomic, assign, readwrite) NSUInteger followers;
@property (nonatomic, assign, readwrite) NSUInteger following;
@property (nonatomic, assign, readwrite) NSUInteger pins;
@property (nonatomic, assign, readwrite) NSUInteger likes;
@property (nonatomic, assign, readwrite) NSUInteger boards;

@end

@implementation PDKUser

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _firstName = dictionary[@"first_name"];
        _lastName = dictionary[@"last_name"];
        _username = dictionary[@"username"];
        _biography = dictionary[@"bio"];
        
        _followers = [self.counts[@"followers"] unsignedIntegerValue];
        _following = [self.counts[@"following"] unsignedIntegerValue];
        _pins = [self.counts[@"pins"] unsignedIntegerValue];
        _likes = [self.counts[@"likes"] unsignedIntegerValue];
        _boards = [self.counts[@"boards"] unsignedIntegerValue];
    }
    return self;
}

+ (instancetype)userFromDictionary:(NSDictionary *)dictionary
{
    return [[PDKUser alloc] initWithDictionary:dictionary];
}

+ (NSSet *)allFields
{
    return [NSSet setWithArray:@[@"id",
                                 @"username",
                                 @"first_name",
                                 @"last_name",
                                 @"bio",
                                 @"created_at",
                                 @"counts",
                                 @"image"]];
}

@end
