//  Copyright (c) 2015 Pinterest. All rights reserved.
//  Created by Garrett Moon on 2/24/15.

#import "PDKCategories.h"

@implementation NSDictionary (PDKAdditions)
+ (NSDictionary *)_PDK_dictionaryWithQueryString:(NSString *)queryString
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs)
    {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        if (elements.count == 2)
        {
            NSString *key = elements[0];
            NSString *value = elements[1];
            NSString *decodedKey = [key _PDK_urlDecodedString];
            NSString *decodedValue = [value _PDK_urlDecodedString];
            
            if (![key isEqualToString:decodedKey])
                key = decodedKey;
            
            if (![value isEqualToString:decodedValue])
                value = decodedValue;
            
            dictionary[key] = value;
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSString *)_PDK_queryStringValue
{
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [self keyEnumerator])
    {
        id value = self[key];
        NSString *escapedValue = [value _PDK_urlEncodedString];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escapedValue]];
    }
    
    return [pairs componentsJoinedByString:@"&"];
}

- (NSDictionary *)_PDK_dictionaryByRemovingNulls
{
    NSMutableDictionary *newDictionary = [NSMutableDictionary dictionaryWithDictionary:self];
    const id null = [NSNull null];
    
    for (NSString *key in self) {
        const id object = self[key];
        if (object == null) {
            [newDictionary removeObjectForKey:key];
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            newDictionary[key] = [(NSDictionary *) object _PDK_dictionaryByRemovingNulls];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:newDictionary];
}

@end

@implementation NSString (PDKAdditions)

- (NSString *)_PDK_urlDecodedString
{
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                 (__bridge CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 kCFStringEncodingUTF8);
}

- (NSString *)_PDK_urlEncodedString
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 kCFStringEncodingUTF8);
}

@end
