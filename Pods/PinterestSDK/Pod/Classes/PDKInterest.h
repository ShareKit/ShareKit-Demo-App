//
//  PDKInterest.h
//  Pods
//
//  Created by Ricky Cancro on 3/17/15.
//
//

@import Foundation;

/**
 *  A class that represents an interest
 */
@interface PDKInterest : NSObject

/**
 *  The identifier of the interest
 */
@property (nonatomic, copy, readonly) NSString *identifier;

/**
 *  The name of the interest
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 *  Given a dictionary of parsed JSON created a PDKInterest object
 *
 *  @param dictionary Dictionary of parsed JSON
 *
 *  @return A PDKInterest objecct
 */
+ (instancetype)interestFromDictionary:(NSDictionary *)dictionary;
@end
