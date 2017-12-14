//  Copyright (c) 2015 Pinterest. All rights reserved.
//  Created by Ricky Cancro on 3/6/15.

#import "PDKResponseObject.h"

#import "PDKBoard.h"
#import "PDKCategories.h"
#import "PDKInterest.h"
#import "PDKPin.h"
#import "PDKUser.h"

@interface PDKResponseObject()
@property (nonatomic, strong) NSMutableDictionary *parameters;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *cursor;
@property (nonatomic, assign) NSUInteger statusCode;
@end


@implementation PDKResponseObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary response:(NSHTTPURLResponse *)response
{
    return [self initWithDictionary:dictionary response:response path:nil parameters:nil];
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionary response:(NSHTTPURLResponse *)response path:(NSString *)path parameters:(NSDictionary *)parameters
{
    self = [super init];
    if (self) {
        _statusCode = response.statusCode;
        _parsedJSONDictionary = [dictionary _PDK_dictionaryByRemovingNulls];
        _cursor = _parsedJSONDictionary[@"page"][@"cursor"];
        _path = path;
        _parameters = [parameters mutableCopy];
    }
    return self;
}

+ (NSArray *)usersFromArray:(NSArray *)jsonArray
{
    NSMutableArray *users = [NSMutableArray arrayWithCapacity:[jsonArray count]];
    for (NSDictionary *user in jsonArray) {
        [users addObject:[PDKUser userFromDictionary:user]];
    }
    return [NSArray arrayWithArray:users];
}

- (NSArray *)users
{
    NSArray *userData = self.parsedJSONDictionary[@"data"];
    NSArray *users = nil;
    if ([userData isKindOfClass:[NSArray class]]) {
        users = [PDKResponseObject usersFromArray:userData];
    }
    return users;
}

+ (NSArray *)boardsFromArray:(NSArray *)jsonArray
{
    NSMutableArray *boards = [NSMutableArray arrayWithCapacity:[jsonArray count]];
    for (NSDictionary *board in jsonArray) {
        [boards addObject:[PDKBoard boardFromDictionary:board]];
    }
    return [NSArray arrayWithArray:boards];
}

- (NSArray *)boards
{
    NSArray *boardData = self.parsedJSONDictionary[@"data"];
    NSArray *boards = nil;
    if ([boardData isKindOfClass:[NSArray class]]) {
        boards = [PDKResponseObject boardsFromArray:boardData];
    }
    return boards;
}

+ (NSArray *)pinsFromArray:(NSArray *)jsonArray;
{
    NSMutableArray *pins = [NSMutableArray arrayWithCapacity:[jsonArray count]];
    for (NSDictionary *pin in jsonArray) {
        [pins addObject:[PDKPin pinFromDictionary:pin]];
    }
    return [NSArray arrayWithArray:pins];
}

- (NSArray *)pins
{
    NSArray *pinData = self.parsedJSONDictionary[@"data"];
    NSArray *pins = nil;
    if ([pinData isKindOfClass:[NSArray class]]) {
        pins = [PDKResponseObject pinsFromArray:pinData];
    }
    return pins;
}

+ (NSArray *)interestsFromArray:(NSArray *)jsonArray;
{
    NSMutableArray *interests = [NSMutableArray arrayWithCapacity:[jsonArray count]];
    for (NSDictionary *interest in jsonArray) {
        [interests addObject:[PDKInterest interestFromDictionary:interest]];
    }
    return [NSArray arrayWithArray:interests];
}

- (NSArray *)interests;
{
    NSArray *interestData = self.parsedJSONDictionary[@"data"];
    NSArray *interests = nil;
    if ([interestData isKindOfClass:[NSArray class]]) {
        interests = [PDKResponseObject interestsFromArray:interestData];
    }
    return interests;
}

- (BOOL)isValid
{
    return self.statusCode == 200 || self.statusCode == 201;
}

+ (PDKBoard *)boardFromDictionary:(NSDictionary *)jsonDictionary
{
    PDKBoard *board = [PDKBoard boardFromDictionary:jsonDictionary];
    NSAssert(board.identifier, @"all boards should have a description. Perhaps this object is not a pin");
    return board;
}

- (PDKBoard *)board
{
    return [PDKResponseObject boardFromDictionary:self.parsedJSONDictionary[@"data"]];
}

+ (PDKPin *)pinFromDictionary:(NSDictionary *)jsonDictionary
{
    PDKPin *pin = [PDKPin pinFromDictionary:jsonDictionary];
    NSAssert(pin.identifier, @"all pins should have a description. Perhaps this object is not a pin");
    return pin;
}

- (PDKPin *)pin
{
    return [PDKResponseObject pinFromDictionary:self.parsedJSONDictionary[@"data"]];
}

+ (PDKUser *)userFromDictionary:(NSDictionary *)jsonDictionary
{
    PDKUser *user = [PDKUser userFromDictionary:jsonDictionary];
    NSAssert(user.identifier, @"all users should have a first name. Perhaps this object is not a user");
    return user;
}

- (PDKUser *)user
{
    return [PDKResponseObject userFromDictionary:self.parsedJSONDictionary[@"data"]];
}

+ (PDKInterest *)interestFromDictionary:(NSDictionary *)jsonDictionary
{
    PDKInterest *interest = [PDKInterest interestFromDictionary:jsonDictionary];
    NSAssert(interest.name, @"all interests should have a name. Perhaps this object is not an interest");
    return interest;
}

- (PDKInterest *)interest
{
    return [PDKResponseObject interestFromDictionary:self.parsedJSONDictionary];
}

- (BOOL)hasNext
{
    return [self.cursor length];
}

- (void)loadNextWithSuccess:(PDKClientSuccess)successBlock
                 andFailure:(PDKClientFailure)failureBlock
{
    if (self.cursor) {
        self.parameters[@"cursor"] = self.cursor;
    }
    
    [[PDKClient sharedInstance] getPath:self.path parameters:self.parameters withSuccess:successBlock andFailure:failureBlock];
}


@end
