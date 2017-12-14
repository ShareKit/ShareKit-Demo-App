//  Copyright (c) 2015 Pinterest. All rights reserved.
//  Created by Garrett Moon on 2/24/15.

@import Foundation;

@interface NSDictionary (PDKAdditions)

+ (NSDictionary *)_PDK_dictionaryWithQueryString:(NSString *)queryString;
- (NSString *)_PDK_queryStringValue;
- (NSDictionary *)_PDK_dictionaryByRemovingNulls;

@end

@interface NSString (PDKAdditions)

- (NSString *)_PDK_urlEncodedString;
- (NSString *)_PDK_urlDecodedString;

@end
