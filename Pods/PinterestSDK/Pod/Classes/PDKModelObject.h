//
//  PDKModelObject.h
//  Pods
//
//  Created by Ricky Cancro on 3/17/15.
//
//

@import Foundation;
@class PDKImageInfo;

/**
 *  A base class for PDKPin, PDKBoard and PDKUser.
 */
@interface PDKModelObject : NSObject

/**
 *  The object's identifier
 */
@property (nonatomic, copy, readonly) NSString *identifier;

/**
 *  The time the object was created
 */
@property (nonatomic, strong, readonly) NSDate *creationTime;

/**
 *  Contains stats on the object in key=>value pairs. For example, a pin could contain
 *  count such as repins, likes, comments.
 */
@property (nonatomic, strong, readonly) NSDictionary *counts;

/**
 *  A class that holds a url to the object's default image, and the image dimensions
 */
@property (nonatomic, strong, readonly) PDKImageInfo *image;

/**
 *  A dictionary of PDKImageInfo classes that holds different sizes of the object's image
 */
@property (nonatomic, strong, readonly) NSDictionary *images;

/**
 *  Create a PDKObject with the given dictionary of parsed JSON
 *  This method probably shouldn't be called directly. It is used by its subclasses.
 *
 *  @param dictionary A dictionary of parsed JSON
 *
 *  @return new PDKModelObject 
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  Returns the smallest image from the images dictionary
 *
 *  @return PDKImageInfo of the original image
 */
- (PDKImageInfo *)smallestImage;

/**
 *  Returns the largest image from the images dictionary
 *
 *  @return PDKImageInfo of the original image
 */
- (PDKImageInfo *)largestImage;

/**
 *  Returns a set of all the fields for this model object
 *
 *  @return set of all fields in this object
 */
+ (NSSet *)allFields;

@end
