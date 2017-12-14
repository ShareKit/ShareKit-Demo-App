//  Copyright (c) 2015 Pinterest. All rights reserved.
//  Created by Ricky Cancro on 3/16/15.

@import CoreGraphics;

/**
 *  Holds the information about an image returned from an API call
 */
@interface PDKImageInfo : NSObject

/**
 *  The height of the image
 */
@property (nonatomic, assign, readonly) CGFloat width;

/**
 *  The width of the image
 */
@property (nonatomic, assign, readonly) CGFloat height;

/**
 *  The URL of the image
 */
@property (nonatomic, copy, readonly) NSURL *url;


/**
 *  Creates a PDKImage with the given JSON Dictionary
 *
 *  @param dictionary Dictionary of parsed JSON
 *
 *  @return A PDKImage
 */
+ (instancetype)imageFromDictionary:(NSDictionary *)dictionary;

@end
