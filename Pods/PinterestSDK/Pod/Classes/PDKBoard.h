//  Copyright (c) 2015 Pinterest. All rights reserved.
//  Created by Ricky Cancro on 1/28/15.

@import Foundation;
#import "PDKClient.h"
#import "PDKModelObject.h"

@class PDKUser;

/**
 *  A class that represents a user's board. If you are the owner of this board then
 *  you can remove it/add pins to it via the convience methods.
 */
@interface PDKBoard : PDKModelObject

/**
 *  Name of the board
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 *  Description of the board
 */
@property (nonatomic, copy, readonly) NSString *descriptionText;

/**
 *  The user that created this board
 */
@property (nonatomic, strong, readonly) PDKUser *creator;

/**
 *  Number of users that follow this board
 */
@property (nonatomic, assign, readonly) NSUInteger followers;

/**
 *  Number of pins on this board
 */
@property (nonatomic, assign, readonly) NSUInteger pins;

/**
 *  Number of collaborators on this board
 */
@property (nonatomic, assign, readonly) NSUInteger collaborators;


/**
 *  Takes a parsed JSON dictionary and turns it into a PDKBoard
 *
 *  @param dictionary A dictionary of parsed JSON
 *
 *  @return A new PDKBoard
 */
+ (instancetype)boardFromDictionary:(NSDictionary *)dictionary;

@end