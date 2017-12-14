//
//  PDKModelObject.m
//  Pods
//
//  Created by Ricky Cancro on 3/17/15.
//
//

#import "PDKModelObject.h"

#import "PDKImageInfo.h"

@implementation PDKModelObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
{
    self = [super init];
    if (self) {
    
        _identifier = dictionary[@"id"];
        
        NSTimeInterval creationTimestamp = [dictionary[@"created_at"] doubleValue];
        _creationTime = [NSDate dateWithTimeIntervalSince1970:creationTimestamp];
        
        _images = dictionary[@"image"];
        _counts = dictionary[@"counts"];
    }
    return self;
    
}

- (NSArray *)imagesDictionariesSortedBySize
{
    NSArray *imageDictionaries = [self.images allValues];
    NSArray *sortedArray = [imageDictionaries sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(NSDictionary *dictOne, NSDictionary *dictTwo) {
        PDKImageInfo *infoOne = [PDKImageInfo imageFromDictionary:dictOne];
        PDKImageInfo *infoTwo = [PDKImageInfo imageFromDictionary:dictTwo];
        CGFloat sizeOne = infoOne.width * infoOne.height;
        CGFloat sizeTwo = infoTwo.width * infoTwo.height;
        if (sizeOne > sizeTwo) {
            return NSOrderedDescending;
        } else if (sizeOne < sizeTwo) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    return sortedArray;
}

- (PDKImageInfo *)smallestImage
{
    PDKImageInfo *imageInfo = nil;
    NSDictionary *infoDictionary = [[self imagesDictionariesSortedBySize] firstObject];
    if (infoDictionary) {
        imageInfo = [PDKImageInfo imageFromDictionary:infoDictionary];
    }
    return imageInfo;
}

- (PDKImageInfo *)largestImage
{
    PDKImageInfo *imageInfo = nil;
    NSDictionary *infoDictionary = [[self imagesDictionariesSortedBySize] lastObject];
    if (infoDictionary) {
        imageInfo = [PDKImageInfo imageFromDictionary:infoDictionary];
    }
    return imageInfo;
}

+ (NSSet *)allFields
{
    return [NSSet set];
}

@end
