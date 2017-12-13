// PKMultipartInputStream.h
// py.kerembellec@gmail.com

#import <Foundation/Foundation.h>

@interface PKMultipartInputStream : NSInputStream
- (void)addPartWithName:(NSString *)name string:(NSString *)string;
- (void)addPartWithName:(NSString *)name data:(NSData *)data;
- (void)addPartWithName:(NSString *)name data:(NSData *)data contentType:(NSString *)type;
- (void)addPartWithName:(NSString *)name filename:(NSString*)filename data:(NSData *)data contentType:(NSString *)type;
- (void)addPartWithName:(NSString *)name path:(NSString *)path;
- (void)addPartWithName:(NSString *)name filename:(NSString *)filename path:(NSString *)path;
- (void)addPartWithName:(NSString *)name filename:(NSString *)filename stream:(NSInputStream *)stream streamLength:(NSUInteger)streamLength;
- (void)addPartWithHeaders:(NSDictionary *)headers string:(NSString *)string;
- (void)addPartWithHeaders:(NSDictionary *)headers path:(NSString *)path;

@property (nonatomic, readonly) NSString *boundary;
@property (nonatomic, readonly) NSUInteger length;

@end
