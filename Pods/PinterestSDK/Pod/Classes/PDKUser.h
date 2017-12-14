//  Copyright (c) 2015 Pinterest. All rights reserved.
//  Created by Ricky Cancro on 1/28/15.

@import Foundation;
#import "PDKClient.h"
#import "PDKModelObject.h"

/**
 *  A class that represents a Pinterest user.
 */
@interface PDKUser : PDKModelObject

/**
 *  User's first name
 */
@property (nonatomic, copy, readonly) NSString *firstName;

/**
 *  User's last name
 */
@property (nonatomic, copy, readonly) NSString *lastName;

/**
 *  The user's username
 */
@property (nonatomic, copy, readonly) NSString *username;

/**
 *  The user's biography
 */
@property (nonatomic, copy, readonly) NSString *biography;

/**
 *  The number of Pinterest users that follow this user
 */
@property (nonatomic, assign, readonly) NSUInteger followers;

/**
 *  The number of Pinterest users this user follows
 */
@property (nonatomic, assign, readonly) NSUInteger following;

/**
 *  The number of pins this user has
 */
@property (nonatomic, assign, readonly) NSUInteger pins;

/**
 *  The number of likes this user has
 */
@property (nonatomic, assign, readonly) NSUInteger likes;

/**
 *  The number of boards this user has
 */
@property (nonatomic, assign, readonly) NSUInteger boards;

/**
 *  Creates a PDKUser from the given JSON dictionary
 *
 *  @param dictionary Dictionary of parsed JSON
 *
 *  @return a PDKUser
 */
+ (instancetype)userFromDictionary:(NSDictionary *)dictionary;

@end