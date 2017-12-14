//  Copyright (c) 2015 Pinterest. All rights reserved.
//  Created by Ricky Cancro on 3/6/15.

@import Foundation;

@class PDKBoard;
@class PDKInterest;
@class PDKPin;
@class PDKUser;

#import "PDKClient.h"

typedef void (^PDKResponseObjectLoadedSuccess)();
typedef void (^PDKResponseObjectLoadedFailure)(NSError *error);

/**
 *  A PDKResponseObject encapsulates the response from an API call. Based on the call that was made, 
 *  the appropriate method can be called to get the expected return type. For example, if a call is made
 *  to get a user's pins, calling the pins method on the responseObject will return an array of pins. If 
 *  the responseObject actually contains a list of boards and calling pins will return invalid data.
 *
 *  If the response is from a paged request, calling loadNextWithSuccess:andFailure will return a new
 *  responseObject with the 2nd page of data. To get the 3rd page of data, call loadNextWithSuccess:andFailure
 *  on the newly returned responseObject.
 */
@interface PDKResponseObject : NSObject

/**
 *  The parsedJSON that the API returned.
 */
@property (nonatomic, strong) NSDictionary *parsedJSONDictionary;

/**
 *  For internal use only;
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary response:(NSHTTPURLResponse *)response path:(NSString *)path parameters:(NSDictionary *)parameters;
/**
 *  For internal use only;
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary response:(NSHTTPURLResponse *)response;


/**
 *  Class method to return an array of pins given a JSON array
 *
 *  @param jsonArray An array of parsed JSON
 *
 *  @return an array of PDKPins
 */
+ (NSArray *)pinsFromArray:(NSArray *)jsonArray;

/**
 *  Creates an array of PDKPins from the responseObject's parsedJSONDictionary
 *
 *  @return an array of PDKPins
 */
- (NSArray *)pins;

/**
 *   Class method to return an array of boards given a JSON array
 *
 *  @param jsonArray An array of parsed JSON
 *
 *  @return an array of PDKBoards
 */
+ (NSArray *)boardsFromArray:(NSArray *)jsonArray;

/**
 *  Creates an array of PDKBoards from the responseObject's parsedJSONDictionary
 *
 *  @return an array of PDKBoards
 */
- (NSArray *)boards;

/**
 *   Class method to return an array of users given a JSON array
 *
 *  @param jsonArray An array of parsed JSON
 *
 *  @return an array of PDKUsers
 */
+ (NSArray *)usersFromArray:(NSArray *)jsonArray;

/**
 *  Creates an array of PDKUsers from the responseObject's parsedJSONDictionary
 *
 *  @return an array of PDKUsers
 */
- (NSArray *)users;

/**
 *   Class method to return an array of interests given a JSON array
 *
 *  @param jsonArray An array of parsed JSON
 *
 *  @return an array of PDKInterests
 */
+ (NSArray *)interestsFromArray:(NSArray *)jsonArray;

/**
 *  Creates an array of PDKInterests from the responseObject's parsedJSONDictionary
 *
 *  @return an array of PDKInterests
 */
- (NSArray *)interests;

/**
 *  Creates a PDKPin from the given dictionary
 *
 *  @param jsonDictionary Dictionary of parsed JSON
 *
 *  @return a PDKPin
 */
+ (PDKPin *)pinFromDictionary:(NSDictionary *)jsonDictionary;

/**
 *  Creates a PDKPin from this object's parsedJSONDictionary
 *
 *  @return a PDKPin
 */
- (PDKPin *)pin;

/**
 *  Creates a PDKBoard from the given dictionary
 *
 *  @param jsonDictionary Dictionary of parsed JSON
 *
 *  @return a PDKBoard
 */
+ (PDKBoard *)boardFromDictionary:(NSDictionary *)jsonDictionary;

/**
 *  Creates a PDKBoard from this object's parsedJSONDictionary
 *
 *  @return a PDKBoard
 */
- (PDKBoard *)board;

/**
 *  Creates a PDKUser from the given dictionary
 *
 *  @param jsonDictionary Dictionary of parsed JSON
 *
 *  @return a PDKUser
 */
+ (PDKUser *)userFromDictionary:(NSDictionary *)jsonDictionary;

/**
 *  Creates a PDKUser from this object's parsedJSONDictionary
 *
 *  @return a PDKUser
 */
- (PDKUser *)user;

/**
 *  Creates a PDKInterest from the given dictionary
 *
 *  @param jsonDictionary Dictionary of parsed JSON
 *
 *  @return a PSKInterest
 */
+ (PDKInterest *)interestFromDictionary:(NSDictionary *)jsonDictionary;

/**
 *  Creates a PDKInterest from this object's parsedJSONDictionary
 *
 *  @return a PDKInterest
 */
- (PDKInterest *)interest;


/**
 *  A check to see if this responseObject is valid
 *
 *  @return YES is the object is valid
 */
- (BOOL)isValid;

/**
 *  Checks to see if this response object can return another page of data
 *
 *  @return YES if there is another page of data
 */
- (BOOL)hasNext;

/**
 *  Loads the next page of data
 *
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)loadNextWithSuccess:(PDKClientSuccess)successBlock
                 andFailure:(PDKClientFailure)failureBlock;


@end
