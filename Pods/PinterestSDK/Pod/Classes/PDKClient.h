//  Copyright (c) 2015 Pinterest. All rights reserved.
//  Created by Ricky Cancro on 1/28/15.

@import Foundation;
#import <AFNetworking/AFNetworking.h>

/**
 *  Permissions that you can request a user to authorize.
 */
extern NSString * const PDKClientReadPublicPermissions;
extern NSString * const PDKClientWritePublicPermissions;
extern NSString * const PDKClientReadPrivatePermissions;
extern NSString * const PDKClientWritePrivatePermissions;
extern NSString * const PDKClientReadRelationshipsPermissions;
extern NSString * const PDKClientWriteRelationshipsPermissions;

/**
 *  The base string of all the SDK endpoints
 */
extern NSString * const kPDKClientBaseURLString;

@class PDKBoard;
@class PDKPin;
@class PDKResponseObject;
@class PDKUser;

/**
 *  The signature for the block that is called for all API requests that succeed
 *
 *  @param responseObject The object that was returned from the API call
 */
typedef void (^PDKClientSuccess)(PDKResponseObject *responseObject);

/**
 *  The signature for the block that is called for all API requests that fail
 *
 *  @param error The error that the API call encountered
 */
typedef void (^PDKClientFailure)(NSError *error);

/**
 *  The signature for the block that is periodically called while uploading a local image
 *  so the user can show some type of progress
 *
 *  @param percentComplete The percent complete
 */
typedef void (^PDKPinUploadProgress)(CGFloat percentComplete);


/**
 *  Use the PDKClient to interact with the Pinterest SDK. Before making API calls
 *  the client must be configured with an appId. Once configured,
 *  authenticateWithPermissions:withSuccess:andFailure needs to be called to get the user's
 *  permission to access his/her account.
 *
 *  Once authenticated, calls can be made by passing in endpoints directly (using
 *  methods like getPath:parameters:success:failure:) or by using convience methods
 *  (like getPinsForBoard:success:failure)
 */
@interface PDKClient : AFHTTPSessionManager

/**
 *  The assigned appId that is used to make API requests
 */
@property (nonatomic, readonly, copy) NSString *appId;

/**
 *  The oauthToken returned from the server unpon authentication. If you store this in your
 *  app, please be sure to do so securely (in keychain) and be warned that it can expire
 *  at any time. If the token expires, you will need to reauthenticate and get a new token.
 */
@property (nonatomic, copy) NSString *oauthToken;

/**
 *  Set to YES when the client is authorized and requests can be made
 */
@property (nonatomic, readonly) BOOL authorized;

/**
 *  PDKClient is a singleton. This will return the one instance of the client.
 *
 *  @return A PDKClient object
 */
+ (instancetype)sharedInstance;

/**
 *  Before making API requests via the client, use this method to configure
 *  the client with an appId.
 *
 *  @param appId appId needed to make API requests
 */
+ (void)configureSharedInstanceWithAppId:(NSString *)appId;

#pragma mark - Authentication
/**
 *  Called to ask for a Pinterest user's permission to access his/her account. This method
 *  will either redirect to the Pinterest app (if installed) or to a website to allow a
 *  user to authuorize his/her account.
 *
 *  This method will try to use the cached token to authenticate if it is available. If not,
 *  then the user will be redirected to authenticate. If you wish to silently authenticate if
 *  a user's cached token is still valid, try silentlyAuthenticateWithSuccess:andFailure:.
 *
 *  @param permissions  List of permissions to request from the user's Pinterest account
 *  @param successBlock called when the API request succeeds
 *  @param failureBlock called when the API request fails
 */
- (void)authenticateWithPermissions:(NSArray *)permissions
                        withSuccess:(PDKClientSuccess)successBlock
                         andFailure:(PDKClientFailure)failureBlock;

/**
 *  This method will use the cached oauth token and permission to populate PDKClient's oauthToken
 *  property. If there is no cached oauth token this method will call the failure block and do 
 *  nothing else (i.e., no app switching to authenticate). 
 *
 *  @param successBlock called if the cached token can be used to authenticate
 *  @param failureBlock called if there is no cached token
 */
- (void)silentlyAuthenticateWithSuccess:(PDKClientSuccess)successBlock
                                 andFailure:(PDKClientFailure)failureBlock;

/**
 *  After the user authorizes his/her Pinterest account, control switches back to the
 *  calling application. Placing a call to this method in application:handleOpenURL: will
 *  parse the oauth token out of the URL and call the successBlock or failureBlock that were
 *  passed into authenticateWithPermissions:withSuccess:andFailure. This method will also
 *  store the user's oauth token in the keychain.
 *
 *  @param url The URL that was passed into the application
 *
 *  @return YES if the URL was handled by PDKClient
 */
- (BOOL)handleCallbackURL:(NSURL *)url;

/**
 *  Removes the saved oauth token for the currently authorized user.
 */
+ (void)clearAuthorizedUser;


#pragma mark - Generic API access
/**
 *  Makes a GET API request
 *
 *  @param path         The path to endpoint
 *  @param parameters   Any parameters that need to be sent to the endpoint
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
    withSuccess:(PDKClientSuccess)successBlock
     andFailure:(PDKClientFailure)failureBlock;

/**
 *  Makes a DELETE API request
 *
 *  @param path         The path to the endpoint
 *  @param parameters   Any parameters that need to be sent to the endpoint
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)deletePath:(NSString *)path
        parameters:(NSDictionary *)parameters
       withSuccess:(PDKClientSuccess)successBlock
        andFailure:(PDKClientFailure)failureBlock;

/**
 *  Makes a PUT API request
 *
 *  @param path         The path to the endpoint
 *  @param parameters   Any parameters that need to be sent to the endpoint
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
    withSuccess:(PDKClientSuccess)successBlock
     andFailure:(PDKClientFailure)failureBlock;

/**
 *  Makes a POST API request
 *
 *  @param path         The path to the endpoint
 *  @param parameters   Any parameters that need to be sent to the endpoint
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
     withSuccess:(PDKClientSuccess)successBlock
      andFailure:(PDKClientFailure)failureBlock;

/**
 *  Makes a PATCH API request
 *
 *  @param path         The path to the endpoint
 *  @param parameters   Any parameters that need to be sent to the endpoint
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)patchPath:(NSString *)path
       parameters:(NSDictionary *)parameters
      withSuccess:(PDKClientSuccess)successBlock
       andFailure:(PDKClientFailure)failureBlock;


#pragma mark - User Endpoints
/**
 *  Get a PDKUser object for the currently authorized user
 *
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)getAuthorizedUserFields:(NSSet *)fields
                    withSuccess:(PDKClientSuccess)success
                     andFailure:(PDKClientFailure)failure;

/**
 *  Get a PDKUser with the given username
 *
 *  @param username     username (or ID) of a Pinterest user
 *  @param fields       The user fields that will be returned by the api
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)getUser:(NSString *)username
         fields:(NSSet *)fields
    withSuccess:(PDKClientSuccess)successBlock
     andFailure:(PDKClientFailure)failureBlock;

/**
 *  Get a list of the authorized user's pins. The response can be
 *  used to get the next page of pins.
 *
 *  @param fields       The pins fields that will be returned by the api
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)getAuthenticatedUserPinsWithFields:(NSSet *)fields
                                   success:(PDKClientSuccess)successBlock
                                andFailure:(PDKClientFailure)failureBlock;

/**
 *  Get a list of the authorized user's likes. The reponse can be used to get the
 *  next page of likes.
 *
 *  @param fields       The pin fields that will be returned by the api
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)getAuthenticatedUserLikesWithFields:(NSSet *)fields
                                    success:(PDKClientSuccess)successBlock
                                 andFailure:(PDKClientFailure)failureBlock;

/**
 *  Get a list of the authorized user's boards. The reponse can be used to
 *  get the next page of boards.
 *
 *  @param fields       The board fields that will be returned by the api
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)getAuthenticatedUserBoardsWithFields:(NSSet *)fields
                                     success:(PDKClientSuccess)successBlock
                                  andFailure:(PDKClientFailure)failureBlock;
/**
 *  Get a list of the authorized user's followers. The response can be used to
 *  get the next page of followers (PDKUsers)
 *
 *  @param fields       The user fields that will be returned by the api
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)getAuthorizedUserFollowersWithFields:(NSSet *)fields
                                     success:(PDKClientSuccess)successBlock
                                  andFailure:(PDKClientFailure)failureBlock;

/**
 *  Get a list of the users the  authorized user follows. The response can be used to
 *  get the next page of followers (PDKUsers)
 *
 *  @param fields       The user fields that will be returned by the api
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)getAuthorizedUserFollowedUsersWithFields:(NSSet *)fields
                                         success:(PDKClientSuccess)successBlock
                                      andFailure:(PDKClientFailure)failureBlock;

/**
 *  Get a list of the boards the  authorized user follows. The response can be used to
 *  get the next page of followers (PDKUsers)
 *
 *  @param fields       The board fields that will be returned by the api
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)getAuthorizedUserFollowedBoardsWithFields:(NSSet *)fields
                                          success:(PDKClientSuccess)successBlock
                                       andFailure:(PDKClientFailure)failureBlock;

/**
 *  Get a list of the interests the  authorized user follows. The response can be used to
 *  get the next page of followers (PDKUsers)
 *
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)getAuthorizedUserFollowedInterestsWithSuccess:(PDKClientSuccess)successBlock
                                           andFailure:(PDKClientFailure)failureBlock;


#pragma mark - Board endpoints
/**
 *  Get a PDKBoard object for the given board ID
 *
 *  @param boardId      ID of the board to fetch
 *  @param fields       The board fields that will be returned by the api
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)getBoardWithIdentifier:(NSString *)boardId
                        fields:(NSSet *)fields
                   withSuccess:(PDKClientSuccess)successBlock
                    andFailure:(PDKClientFailure)failureBlock;

/**
 *  Get a list of pins for the given board. The response can be used to get
 *  the bext page of pins.
 *
 *  @param boardId      ID of the board
 *  @param fields       The pin fields that will be returned by the api
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)getBoardPins:(NSString *)boardId
              fields:(NSSet *)fields
         withSuccess:(PDKClientSuccess)successBlock
          andFailure:(PDKClientFailure)failureBlock;

/**
 *  Delete the given board
 *
 *  @param boardId      ID of board to delete
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)deleteBoard:(NSString *)boardId
        withSuccess:(PDKClientSuccess)successBlock
         andFailure:(PDKClientFailure)failureBlock;

/**
 *  Create a board. The reponse object will contain the new PDKBoard
 *
 *  @param boardName    Name of the new board
 *  @param description  Description of the new board
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)createBoard:(NSString *)boardName
   boardDescription:(NSString *)description
        withSuccess:(PDKClientSuccess)successBlock
         andFailure:(PDKClientFailure)failureBlock;

#pragma mark - Pins
/**
 *  Get a PDKPin for the given pinID
 *
 *  @param pinId        ID of the pin to fetch
 *  @param fields       The pin fields that will be returned by the api
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)getPinWithIdentifier:(NSString *)pinId
                      fields:(NSSet *)fields
                 withSuccess:(PDKClientSuccess)successBlock
                  andFailure:(PDKClientFailure)failureBlock;

/**
 *  Creates a new pin from a URL
 *
 *  @param imageURL       The URL to the image to pin
 *  @param link           A URL to the source page
 *  @param boardId        ID of the board to pin to
 *  @param pinDescription Description for the pin
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)createPinWithImageURL:(NSURL *)imageURL
                         link:(NSURL *)link
                      onBoard:(NSString *)boardId
                  description:(NSString *)pinDescription
                  withSuccess:(PDKClientSuccess)successBlock
                   andFailure:(PDKClientFailure)failureBlock;
/**
 *  Delete the given pin
 *
 *  @param pinId        ID of pin to delete
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)deletePin:(NSString *)pinId
      withSuccess:(PDKClientSuccess)successBlock
       andFailure:(PDKClientFailure)failureBlock;

/**
 *  Creates a new pin from a UIImage
 *
 *  @param image          a UIImage to pin
 *  @param link           A URL to the source page
 *  @param boardId        Id of the board to pin to
 *  @param pinDescription Description of the pin
 *  @param progressBlock  Block called periodically as the UIImage uploads
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
- (void)createPinWithImage:(UIImage *)image
                      link:(NSURL *)link
                   onBoard:(NSString *)boardId
               description:(NSString *)pinDescription
                  progress:(PDKPinUploadProgress)progressBlock
               withSuccess:(PDKClientSuccess)successBlock
                andFailure:(PDKClientFailure)failureBlock;

/**
 *  Method used to open a URL. In iOS9 if the URL is a web address it uses SFSafariViewController. 
 * In earlier versions it uses UIApplication's openURL
 */
+ (void)openURL:(NSURL *)url;

@end
