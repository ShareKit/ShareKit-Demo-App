//  Copyright (c) 2015 Pinterest. All rights reserved.
//  Created by Ricky Cancro on 1/28/15.

#import "PDKClient.h"

#import "PDKBoard.h"
#import "PDKCategories.h"
#import "PDKPin.h"
#import "PDKResponseObject.h"
#import "PDKUser.h"

#import <SSKeychain/SSKeychain.h>
@import UIKit;
@import SafariServices;

NSString * const PDKClientReadPublicPermissions = @"read_public";
NSString * const PDKClientWritePublicPermissions = @"write_public";
NSString * const PDKClientReadPrivatePermissions = @"read_private";
NSString * const PDKClientWritePrivatePermissions = @"write_private";
NSString * const PDKClientReadRelationshipsPermissions = @"read_relationships";
NSString * const PDKClientWriteRelationshipsPermissions = @"write_relationships";

NSString * const kPDKClientBaseURLString = @"https://api.pinterest.com/v1/";

static NSString * const PDKPinterestSDK = @"pinterestSDK";
static NSString * const PDKPinterestSDKUsername = @"authenticatedUser";

static NSString * const PDKPinterestSDKPermissionsKey = @"PDKPinterestSDKPermissionsKey";
static NSString * const PDKPinterestSDKAppIdKey = @"PDKPinterestSDKAppIdKey";
static NSString * const PDKPinterestSDKUserIdKey = @"PDKPinterestSDKUserIdKey";

static NSString * const kPDKPinterestAppOAuthURLString = @"pinterestsdk.v1://oauth/";
static NSString * const kPDKPinterestWebOAuthURLString = @"https://api.pinterest.com/oauth/";

@interface PDKClient()
@property (nonatomic, assign) BOOL configured;
@property (nonatomic, copy, readwrite) NSString *appId;
@property (nonatomic, copy) NSString *clientRedirectURLString;
@property (nonatomic, assign, readwrite) BOOL authorized;
@property (nonatomic, copy) PDKClientSuccess authenticationSuccessBlock;
@property (nonatomic, copy) PDKClientFailure authenticationFailureBlock;

@end

@implementation PDKClient

+ (instancetype)sharedInstance
{
    static PDKClient *gClientSDK;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gClientSDK = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:kPDKClientBaseURLString]];
    });
    return gClientSDK;
}

+ (void)configureSharedInstanceWithAppId:(NSString *)appId
{
    [[self sharedInstance] setAppId:appId];
    [[self sharedInstance] setClientRedirectURLString:[NSString stringWithFormat:@"pdk%@", appId]];
    [[self sharedInstance] setConfigured:YES];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL
{
    if (self = [super initWithBaseURL:baseURL]) {
        _configured = NO;
        _authorized = NO;
    }
    return self;
}

- (NSString *)appId
{
    NSAssert(self.configured == YES, @"PDKClient must be configured before use. Call [PDK configureShareInstanceWithAppId:]");
    return _appId;
}

- (void)inspectToken:(NSString *)oauthToken
         withSuccess:(PDKClientSuccess)successBlock
          andFailure:(PDKClientFailure)failureBlock
{
    [[[self class] sharedInstance] getPath:@"oauth/inspect"
                                parameters:@{@"access_token":oauthToken,
                                             @"token":oauthToken}
                               withSuccess:successBlock
                                andFailure:failureBlock];
    
    
}

- (BOOL)verifyTokenDetails:(NSDictionary *)dictionary
{
    BOOL verified = NO;
    NSDictionary *dataDictionary = dictionary[@"data"];
    if (dataDictionary) {
        NSArray *permissions = dataDictionary[@"scopes"];
        NSNumber *userId = dataDictionary[@"user_id"];
        
        NSDictionary *appDictionary = dataDictionary[@"app"];
        if (appDictionary) {
            NSNumber *appId = appDictionary[@"id"];
            
            NSArray *cachedPermissions = [[NSUserDefaults standardUserDefaults] objectForKey:PDKPinterestSDKPermissionsKey];
            NSNumber *cachedAppId = [[NSUserDefaults standardUserDefaults] objectForKey:PDKPinterestSDKAppIdKey];
            NSNumber *cachedUserId = [[NSUserDefaults standardUserDefaults] objectForKey:PDKPinterestSDKUserIdKey];
            
            permissions = [permissions sortedArrayUsingSelector:@selector(compare:)];
            verified =  cachedAppId && cachedPermissions && cachedUserId &&
            [appId isEqualToNumber:cachedAppId] &&
            [permissions isEqualToArray:cachedPermissions] &&
            [userId isEqualToNumber:cachedUserId];
        }
    }
    
    return verified;
}

- (void)recordTokenDetails:(NSDictionary *)dictionary
{
    NSDictionary *dataDictionary = dictionary[@"data"];
    if (dataDictionary) {
        NSArray *permissions = dataDictionary[@"scopes"];
        NSNumber *userId = dataDictionary[@"user_id"];
        
        NSDictionary *appDictionary = dataDictionary[@"app"];
        if (appDictionary) {
            NSNumber *appId = appDictionary[@"id"];
            
            permissions = [permissions sortedArrayUsingSelector:@selector(compare:)];
            [[NSUserDefaults standardUserDefaults] setObject:permissions forKey:PDKPinterestSDKPermissionsKey];
            [[NSUserDefaults standardUserDefaults] setObject:userId forKey:PDKPinterestSDKUserIdKey];
            [[NSUserDefaults standardUserDefaults] setObject:appId forKey:PDKPinterestSDKAppIdKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

// authentication

- (void)silentlyAuthenticateWithSuccess:(PDKClientSuccess)successBlock
                             andFailure:(PDKClientFailure)failureBlock
{
    [self authenticateWithPermissions:nil silent:YES withSuccess:successBlock andFailure:failureBlock];
}

- (void)authenticateWithPermissions:(NSArray *)permissions withSuccess:(PDKClientSuccess)successBlock andFailure:(PDKClientFailure)failureBlock
{
    [self authenticateWithPermissions:permissions silent:NO withSuccess:successBlock andFailure:failureBlock];
}

- (void)authenticateWithPermissions:(NSArray *)permissions
                             silent:(BOOL)silent
                        withSuccess:(PDKClientSuccess)successBlock
                         andFailure:(PDKClientFailure)failureBlock
{
    __weak PDKClient *weakSelf = self;
    
    // Check to see if we have a saved token and that the permissions are valid
    NSString *cachedToken = [SSKeychain passwordForService:PDKPinterestSDK account:PDKPinterestSDKUsername];
    NSArray *cachedPermissions = [[NSUserDefaults standardUserDefaults] objectForKey:PDKPinterestSDKPermissionsKey];
    if (cachedToken && cachedPermissions) {
        
        PDKClientFailure localFailureBlock = ^(NSError *error) {
            if (permissions != nil) {
                [SSKeychain deletePasswordForService:PDKPinterestSDK account:PDKPinterestSDKUsername];
                [weakSelf authenticateWithPermissions:permissions withSuccess:successBlock andFailure:failureBlock];
            } else if (failureBlock) {
                failureBlock(error);
            }
        };
        
        [self inspectToken:cachedToken
               withSuccess:^(PDKResponseObject *responseObject) {
                   BOOL validCachedCredentials = NO;
                   if ([responseObject isValid]) {
                       if ([weakSelf verifyTokenDetails:responseObject.parsedJSONDictionary]) {
                           weakSelf.authorized = YES;
                           weakSelf.oauthToken = cachedToken;
                           validCachedCredentials = YES;
                           [[PDKClient sharedInstance] getAuthorizedUserFields:[PDKUser allFields]
                                                                   withSuccess:successBlock
                                                                    andFailure:failureBlock];
                       }
                   }
                   
                   if (validCachedCredentials == NO) {
                       localFailureBlock(nil);
                   }
                   
               } andFailure:localFailureBlock];
    } else if (silent == NO) {
        self.authenticationSuccessBlock = successBlock;
        self.authenticationFailureBlock = failureBlock;
        
        NSString *permissionsString = [permissions componentsJoinedByString:@","];
        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        if (appName == nil) {
            appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
        }
        
        NSDictionary *params = @{@"client_id" : self.appId,
                                 @"permissions" : permissionsString,
                                 @"app_name" : appName
                                 };
        
        // check to see if the Pinterest app is installed
        NSURL *oauthURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", kPDKPinterestAppOAuthURLString, [params _PDK_queryStringValue]]];
        
        if ([[UIApplication sharedApplication] canOpenURL:oauthURL]) {
            [PDKClient openURL:oauthURL];
        } else {
            NSString *redirectURL = [NSString stringWithFormat:@"pdk%@://", self.appId];
            params = @{@"client_id" : self.appId,
                       @"scope" : permissionsString,
                       @"redirect_uri" : redirectURL,
                       @"response_type": @"token",
                       };
            
            // open the web oauth
            oauthURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", kPDKPinterestWebOAuthURLString, [params _PDK_queryStringValue]]];
            [PDKClient openURL:oauthURL];
        }
    } else if (silent && failureBlock) {
        // silent was yes, but we did not have a cached token. that counts as a failure.
        failureBlock(nil);
    }

}

+ (void)clearAuthorizedUser
{
    [SSKeychain deletePasswordForService:PDKPinterestSDK account:PDKPinterestSDKUsername];
}

- (BOOL)handleCallbackURL:(NSURL *)url
{
    BOOL handled = NO;
    NSString *urlScheme = [url scheme];
    if ([urlScheme isEqualToString:self.clientRedirectURLString]) {
        // if we came here via SFSafariViewController then we need to dismiss the VC
        if (NSClassFromString(@"SFSafariViewController") != nil) {
            UIViewController *mainViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            if ([[mainViewController presentedViewController] isKindOfClass:[SFSafariViewController class]]) {
                [mainViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }
        
        // get the oauth token
        NSDictionary *parameters = [NSDictionary _PDK_dictionaryWithQueryString:[url query]];
        NSString *method = parameters[@"method"];
        if (method == nil) {
            method = @"auth";
        }
        
        __weak PDKClient *weakSelf = self;
        PDKClientFailure localFailureBlock = ^(NSError *error) {
            if (weakSelf.authenticationFailureBlock) {
                weakSelf.authenticationFailureBlock(error);
                weakSelf.authenticationFailureBlock = nil;
            }
        };
        
        if ([method isEqualToString:@"auth"]) {
            if ([parameters[@"access_token"] length] > 0) {
                NSString *oauthToken = parameters[@"access_token"];
                
                [self inspectToken:oauthToken
                       withSuccess:^(PDKResponseObject *responseObject) {
                           // save the permissions that were just authorized
                           [weakSelf recordTokenDetails:responseObject.parsedJSONDictionary];
                           
                           weakSelf.oauthToken = oauthToken;
                           [SSKeychain setPassword:weakSelf.oauthToken forService:PDKPinterestSDK account:PDKPinterestSDKUsername];
                           
                           [[PDKClient sharedInstance] getAuthorizedUserFields:[PDKUser allFields]
                                                                   withSuccess:^(PDKResponseObject *responseObject) {
                                                                       [PDKClient sharedInstance].authorized = YES;
                                                                       if (weakSelf.authenticationSuccessBlock) {
                                                                           weakSelf.authenticationSuccessBlock(responseObject);
                                                                           weakSelf.authenticationSuccessBlock = nil;
                                                                       }
                                                                   } andFailure:localFailureBlock];
                           
                       } andFailure:localFailureBlock];
                
            } else {
                localFailureBlock(nil);
            }
            handled = YES;
        } else if ([method isEqualToString:@"pinit"]) {
            if (parameters[@"error"]) {
                [PDKPin callUnauthFailureWithError:parameters[@"error"]];
            } else {
                [PDKPin callUnauthSuccess];
            }
            handled = YES;
        }
    }
    return handled;
}

static void defaultSuccessAction(PDKClientSuccess successBlock, NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, NSDictionary *parameters, NSString *path);
static void defaultSuccessAction(PDKClientSuccess successBlock, NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, NSDictionary *parameters, NSString *path)
{
    if (successBlock && [responseObject isKindOfClass:[NSDictionary class]]) {
        PDKResponseObject *response = [[PDKResponseObject alloc] initWithDictionary:(NSDictionary *)responseObject response:(NSHTTPURLResponse *)[task response] path:path parameters:parameters];
        successBlock(response);
    }
}

static void defaultFailureAction(PDKClientFailure failureBlock, NSError *error);
static void defaultFailureAction(PDKClientFailure failureBlock, NSError *error)
{
    if (failureBlock) {
        failureBlock(error);
    }
}

#pragma mark - Endpoints

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
    withSuccess:(PDKClientSuccess)successBlock
     andFailure:(PDKClientFailure)failureBlock;
{
    NSString *urlString = [[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString];
    [self GET:urlString parameters:[self signParameters:parameters] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        defaultSuccessAction(successBlock, task, responseObject, parameters, path);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        defaultFailureAction(failureBlock, error);
    }];
    
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
     withSuccess:(PDKClientSuccess)successBlock
      andFailure:(PDKClientFailure)failureBlock;
{
    NSString *urlString = [[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString];
    [self POST:urlString parameters:[self signParameters:parameters] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        defaultSuccessAction(successBlock, task, responseObject, parameters, path);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        defaultFailureAction(failureBlock, error);
    }];
}

- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
    withSuccess:(PDKClientSuccess)successBlock
     andFailure:(PDKClientFailure)failureBlock;
{
    NSString *urlString = [[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString];
    [self PUT:urlString parameters:[self signParameters:parameters] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        defaultSuccessAction(successBlock, task, responseObject, parameters, path);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        defaultFailureAction(failureBlock, error);
    }];
}

- (void)patchPath:(NSString *)path
     parameters:(NSDictionary *)parameters
    withSuccess:(PDKClientSuccess)successBlock
     andFailure:(PDKClientFailure)failureBlock;
{
    NSString *urlString = [[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString];
    [self PATCH:urlString parameters:[self signParameters:parameters] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        defaultSuccessAction(successBlock, task, responseObject, parameters, path);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        defaultFailureAction(failureBlock, error);
    }];
}

- (void)deletePath:(NSString *)path
        parameters:(NSDictionary *)parameters
       withSuccess:(PDKClientSuccess)successBlock
        andFailure:(PDKClientFailure)failureBlock;
{
    NSString *urlString = [[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString];
    [self DELETE:urlString parameters:[self signParameters:parameters] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        defaultSuccessAction(successBlock, task, responseObject, parameters, path);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        defaultFailureAction(failureBlock, error);
    }];
}

#pragma mark - AFHTTPSessionManager overrides

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler {
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest setHTTPShouldHandleCookies:YES];
    [mutableRequest setValue:@"no-cache, no-store" forHTTPHeaderField:@"Cache-Control"];
    
    return [super dataTaskWithRequest:mutableRequest uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:completionHandler];
}

- (NSURLSessionUploadTask *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                                 progress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                                        completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest setHTTPShouldHandleCookies:YES];
    return [super uploadTaskWithStreamedRequest:mutableRequest progress:uploadProgressBlock completionHandler:completionHandler];
}

#pragma mark - Helpers

- (NSDictionary *)signParameters:(NSDictionary *)parameters
{
    NSMutableDictionary *signedParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    if (self.oauthToken && signedParameters[@"access_token"] == nil) {
        signedParameters[@"access_token"] = self.oauthToken;
    }
    return signedParameters;
}

#pragma mark - User Endpoints

- (void)getAuthorizedUserFields:(NSSet *)fields
                    withSuccess:(PDKClientSuccess)success
                     andFailure:(PDKClientFailure)failure
{
    NSDictionary *parameters = @{@"fields" : [[fields allObjects] componentsJoinedByString:@","]};
    [self getPath:@"me/" parameters:parameters withSuccess:success andFailure:failure];
}

- (void)getUser:(NSString *)username
         fields:(NSSet *)fields
    withSuccess:(PDKClientSuccess)successBlock
     andFailure:(PDKClientFailure)failureBlock;
{
    NSDictionary *parameters = @{@"fields" : [[fields allObjects] componentsJoinedByString:@","]};
    NSString *path = [NSString stringWithFormat:@"users/%@/", username];
    [self getPath:path parameters:parameters withSuccess:successBlock andFailure:failureBlock];
}

- (void)getAuthenticatedUserPinsWithFields:(NSSet *)fields
                                   success:(PDKClientSuccess)successBlock
                                andFailure:(PDKClientFailure)failureBlock
{
    NSDictionary *parameters = @{@"fields" : [[fields allObjects] componentsJoinedByString:@","]};
    [self getPath:@"me/pins/" parameters:parameters withSuccess:successBlock andFailure:failureBlock];
}

- (void)getAuthenticatedUserLikesWithFields:(NSSet *)fields
                                    success:(PDKClientSuccess)successBlock
                                 andFailure:(PDKClientFailure)failureBlock
{
    NSDictionary *parameters = @{@"fields" : [[fields allObjects] componentsJoinedByString:@","]};
    [self getPath:@"me/likes/" parameters:parameters withSuccess:successBlock andFailure:failureBlock];
}

- (void)getAuthenticatedUserBoardsWithFields:(NSSet *)fields
                                     success:(PDKClientSuccess)successBlock
                                  andFailure:(PDKClientFailure)failureBlock
{
    NSDictionary *parameters = @{@"fields" : [[fields allObjects] componentsJoinedByString:@","]};
    [self getPath:@"me/boards/" parameters:parameters withSuccess:successBlock andFailure:failureBlock];
}

- (void)getAuthorizedUserFollowersWithFields:(NSSet *)fields
                                     success:(PDKClientSuccess)successBlock
                                  andFailure:(PDKClientFailure)failureBlock
{
    NSDictionary *parameters = @{@"fields" : [[fields allObjects] componentsJoinedByString:@","]};
    [self getPath:@"me/followers/" parameters:parameters withSuccess:successBlock andFailure:failureBlock];
}

- (void)getAuthorizedUserFollowedUsersWithFields:(NSSet *)fields
                                         success:(PDKClientSuccess)successBlock
                                      andFailure:(PDKClientFailure)failureBlock
{
    NSDictionary *parameters = @{@"fields" : [[fields allObjects] componentsJoinedByString:@","]};
    [self getPath:@"me/following/users/" parameters:parameters withSuccess:successBlock andFailure:failureBlock];
}

- (void)getAuthorizedUserFollowedBoardsWithFields:(NSSet *)fields
                                          success:(PDKClientSuccess)successBlock
                                       andFailure:(PDKClientFailure)failureBlock
{
    NSDictionary *parameters = @{@"fields" : [[fields allObjects] componentsJoinedByString:@","]};
    [self getPath:@"me/following/boards/" parameters:parameters withSuccess:successBlock andFailure:failureBlock];
}

- (void)getAuthorizedUserFollowedInterestsWithSuccess:(PDKClientSuccess)successBlock
                                           andFailure:(PDKClientFailure)failureBlock
{
    [self getPath:@"me/following/interests/" parameters:nil withSuccess:successBlock andFailure:failureBlock];
}

#pragma mark - Board Endpoints

- (void)getBoardWithIdentifier:(NSString *)boardId
                        fields:(NSSet *)fields
                   withSuccess:(PDKClientSuccess)successBlock
                    andFailure:(PDKClientFailure)failureBlock
{
    NSDictionary *parameters = @{@"fields" : [[fields allObjects] componentsJoinedByString:@","]};
    NSString *path = [NSString stringWithFormat:@"boards/%@/", boardId];
    [[PDKClient sharedInstance] getPath:path parameters:parameters withSuccess:successBlock andFailure:failureBlock];
}

- (void)getBoardPins:(NSString *)boardId
              fields:(NSSet *)fields
         withSuccess:(PDKClientSuccess)successBlock
          andFailure:(PDKClientFailure)failureBlock;
{
    NSDictionary *parameters = @{@"fields" : [[fields allObjects] componentsJoinedByString:@","]};
    NSString *path = [NSString stringWithFormat:@"boards/%@/pins/", boardId];
    [self getPath:path parameters:parameters withSuccess:successBlock andFailure:failureBlock];
}

- (void)deleteBoard:(NSString *)boardId
        withSuccess:(PDKClientSuccess)successBlock
         andFailure:(PDKClientFailure)failureBlock;
{
    NSString *path = [NSString stringWithFormat:@"boards/%@/", boardId];
    [self deletePath:path parameters:nil withSuccess:successBlock andFailure:failureBlock];
}

- (void)createBoard:(NSString *)boardName
   boardDescription:(NSString *)description
        withSuccess:(PDKClientSuccess)successBlock
         andFailure:(PDKClientFailure)failureBlock;
{
    NSString *path = @"boards/";
    
    if (description == nil) {
        description = @"";
    }
    NSDictionary *parameters = @{
                                 @"name" : boardName,
                                 @"description" : description
                                 };
    
    [self postPath:path parameters:parameters withSuccess:successBlock andFailure:failureBlock];
    
}

#pragma mark - Pin Endpoints

- (void)getPinWithIdentifier:(NSString *)pinId
                      fields:(NSSet *)fields
                 withSuccess:(PDKClientSuccess)successBlock
                  andFailure:(PDKClientFailure)failureBlock
{
    NSDictionary *parameters = @{@"fields" : [[fields allObjects] componentsJoinedByString:@","]};
    NSString *path = [NSString stringWithFormat:@"pins/%@/", pinId];
    [[PDKClient sharedInstance] getPath:path parameters:parameters withSuccess:successBlock andFailure:failureBlock];
}

- (void)createPinWithImageURL:(NSURL *)imageURL
                         link:(NSURL *)link
                      onBoard:(NSString *)boardId
                  description:(NSString *)pinDescription
                  withSuccess:(PDKClientSuccess)successBlock
                   andFailure:(PDKClientFailure)failureBlock;
{
    NSAssert(pinDescription, @"pinDescription cannot be nil");
    NSAssert(boardId, @"boardId cannot be nil");
    
    NSDictionary *parameters = @{
                                 @"image_url" : imageURL,
                                 @"link" : link.absoluteString,
                                 @"board" : boardId,
                                 @"note" : pinDescription
                                 };
    
    [self createPinWithParameters:parameters withSuccess:successBlock andFailure:failureBlock];
    
}

- (void)deletePin:(NSString *)pinId
      withSuccess:(PDKClientSuccess)successBlock
       andFailure:(PDKClientFailure)failureBlock
{
    NSString *path = [NSString stringWithFormat:@"pins/%@/", pinId];
    [self deletePath:path parameters:nil withSuccess:successBlock andFailure:failureBlock];
}

- (void)createPinWithParameters:(NSDictionary *)parameters
                    withSuccess:(PDKClientSuccess)successBlock
                     andFailure:(PDKClientFailure)failureBlock
{
    [self postPath:@"pins/" parameters:parameters withSuccess:successBlock andFailure:failureBlock];
}

+ (void)openURL:(NSURL *)url
{
    NSString *scheme = [[url scheme] lowercaseString];
    if (NSClassFromString(@"SFSafariViewController") != nil && ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"])) {
        UIViewController *viewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:url];
        [viewController presentViewController:safariViewController animated:YES completion:nil];
    } else if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)createPinWithImage:(UIImage *)image
                      link:(NSURL *)link
                   onBoard:(NSString *)boardId
               description:(NSString *)pinDescription
                  progress:(PDKPinUploadProgress)progressBlock
               withSuccess:(PDKClientSuccess)successBlock
                andFailure:(PDKClientFailure)failureBlock;
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"board"] = boardId;
    parameters[@"note"] = pinDescription;
    if (link != nil) {
        parameters[@"link"] = link;
    }
    
    NSString *path = @"pins/";
    NSString *urlString = [[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString];
    [self POST:urlString parameters:[self signParameters:parameters] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
        [formData appendPartWithFileData:imageData
                                    name:@"image"
                                fileName:@"myphoto.jpg"
                                mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock && [uploadProgress totalUnitCount] > 0) {
            CGFloat percentComplete = (CGFloat)[uploadProgress completedUnitCount]/(CGFloat)[uploadProgress totalUnitCount];
            progressBlock(percentComplete);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        defaultSuccessAction(successBlock, task, responseObject, parameters, path);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        defaultFailureAction(failureBlock, error);
    }];
    
}

@end
