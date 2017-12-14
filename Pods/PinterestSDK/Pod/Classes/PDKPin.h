//  Copyright (c) 2015 Pinterest. All rights reserved.
//  Created by Ricky Cancro on 1/28/15.

@import Foundation;
#import "PDKClient.h"
#import "PDKModelObject.h"

/**
 *  Error codes when creating a pin without authorization
 */
typedef NS_ENUM(NSUInteger, PDKPinError){
    PDKPinErrorNone = 0,
    PDKPinErrorCanceled,
    PDKPinErrorUnknown,
};

/**
 *  Block signature when the unauthorized pin creation succeeds
 */
typedef void (^PDKUnauthPinCreationSuccess)();
/**
 *  Block signature when the unauthorized pin creation fails
 *
 *  @param error Error that caused pin creation to fail
 */
typedef void (^PDKUnauthPinCreationFailure)(NSError *error);


/**
 *  A class that represents a pin.
 */
@interface PDKPin : PDKModelObject

/**
 *  The URL to the pin's content
 */
@property (nonatomic, copy, readonly) NSURL *url;

/**
 *  The URL to the pin itself
 */
@property (nonatomic, copy, readonly) NSURL *pinURL;

/**
 *  The description of the pin
 */
@property (nonatomic, copy, readonly) NSString *descriptionText;

/**
 *  The board that this pin is on
 */
@property (nonatomic, strong, readonly) PDKBoard *board;

/**
 *  The user that created this pin
 */
@property (nonatomic, strong, readonly) PDKUser *creator;

/**
 *  Extra information on the pin including pin type (recipe, article, etc.) and related
 *  data (ingredients, author, etc.)
 */
@property (nonatomic, strong, readonly) NSDictionary *metaData;

/**
 *  The source data for videos, including the title, URL, provider, author name, author URL and provider name.
 */
@property (nonatomic, strong, readonly) NSDictionary *attribution;

/**
 *  Number of times this pin has been repinned
 */
@property (nonatomic, assign, readonly) NSUInteger repins;

/**
 *  Number of times this pin has been liked.
 */
@property (nonatomic, assign, readonly) NSUInteger likes;

/**
 *  The number of comments on this pin
 */
@property (nonatomic, assign, readonly) NSUInteger comments;

/**
 *  Given a dictionary of parsed JSON, creates a PDKPin
 *
 *  @param dictionary Dictionary of JSON
 *
 *  @return the PDKPin for the given dictionary
 */
+ (instancetype)pinFromDictionary:(NSDictionary *)dictionary;

/**
 *  Creates a pin without obtaining an oauth token
 *
 *  @param imageURL           The URL of the image to pin
 *  @param sourceURL          The URL to the source of the pin
 *  @param suggestedBoardName A suggested name of a board to pin to
 *  @param pinDescription     The description of the pin
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
+ (void)pinWithImageURL:(NSURL *)imageURL
                   link:(NSURL *)sourceURL
     suggestedBoardName:(NSString *)suggestedBoardName
                   note:(NSString *)pinDescription
            withSuccess:(PDKUnauthPinCreationSuccess)pinSuccessBlock
             andFailure:(PDKUnauthPinCreationFailure)pinFailureBlock;

/**
 *  Used internally in PDKClient's handleURL: to handle the unauth flow.
 */
+ (void)callUnauthSuccess;
+ (void)callUnauthFailureWithError:(NSString *)error;

@end

