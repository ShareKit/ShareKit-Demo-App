//  Copyright (c) 2015 Pinterest. All rights reserved.
//  Created by Ricky Cancro on 1/28/15.

#import "PDKBoard.h"

#import "PDKClient.h"
#import "PDKImageInfo.h"
#import "PDKUser.h"

@interface PDKBoard()

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *descriptionText;
@property (nonatomic, strong, readwrite) PDKUser *creator;

@property (nonatomic, assign, readwrite) NSUInteger followers;
@property (nonatomic, assign, readwrite) NSUInteger pins;
@property (nonatomic, assign, readwrite) NSUInteger collaborators;

@end

@implementation PDKBoard

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _name = dictionary[@"name"];
        _descriptionText = dictionary[@"description"];
        _creator = [PDKUser userFromDictionary:dictionary[@"creator"]];
        
        _followers = [self.counts[@"followers"] unsignedIntegerValue];
        _pins = [self.counts[@"pins"] unsignedIntegerValue];
        _collaborators = [self.counts[@"collaborators"] unsignedIntegerValue];
    }
    return self;
}

+ (instancetype)boardFromDictionary:(NSDictionary *)dictionary
{
    return [[PDKBoard alloc] initWithDictionary:dictionary];
}

+ (NSSet *)allFields
{
    return [NSSet setWithArray:@[@"id",
                                 @"name",
                                 @"url",
                                 @"description",
                                 @"creator",
                                 @"created_at",
                                 @"counts",
                                 @"image"]];
}

@end
