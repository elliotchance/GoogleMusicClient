#import <Foundation/Foundation.h>
#import "GoogleMusicClientProtocol.h"
#import "GoogleMusicLibraryParserDelegate.h"
#import "GoogleMusicLibraryParser.h"
#import "GoogleMusicClientDelegate.h"
#import "GoogleMusicTrackParser.h"
#import "Track.h"
#import "StreamURLForTrack.h"
#import "Downloader.h"

typedef enum
{
    GoogleMusicClientStageWaitingOnAuthToken,
    GoogleMusicClientStagePerformAuth
} GoogleMusicClientStage;

@interface GoogleMusicClient : NSObject <GoogleMusicClientProtocol, NSURLConnectionDelegate>

@property BOOL loggedIn;
@property NSString *authToken;
@property GoogleMusicClientStage stage;
@property NSString *xtToken;
@property BOOL loginAborted;
@property NSMutableDictionary *theProfileSettings;
@property id<GoogleMusicClientDelegate> loginDelegate;

- (void)resetLoginStatus;
- (void)abortLogin;
+ (NSUInteger)maximumWaitTimeForRequest;
- (void)loadProfileSettings;
- (id)labProfileSetting:(NSString *)name;
- (id)profileSettingForKeyPath:(NSString *)keyPath;
- (void)requestService:(NSString *)service
     completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))handler;
- (void)fetchAllTracksWithDelegate:(id<GoogleMusicLibraryParserDelegate>)delegate;
- (GoogleMusicLibraryParser *)libraryParserWithHTML:(NSString *)html;
- (NSMutableURLRequest *)requestForService:(NSString *)service;
- (NSData *)synchronouslyRequestService:(NSString *)service;

@end
