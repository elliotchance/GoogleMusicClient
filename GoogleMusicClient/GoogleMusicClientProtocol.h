#import <Foundation/Foundation.h>

@protocol GoogleMusicLibraryParserDelegate;
@protocol GoogleMusicClientDelegate;

@protocol GoogleMusicClientProtocol <NSObject>

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
              delegate:(id<GoogleMusicClientDelegate>)delegate;
- (BOOL)isLoggedIn;

// profile settings
- (NSDictionary *)profileSettings;
- (BOOL)desktopNotications;
- (BOOL)useHTML5Audio;
- (BOOL)use5StarRatings;
- (BOOL)viewTrackComments;
- (BOOL)chromecastFireplaceVisualizer;

// account settings
- (BOOL)accountIsCanceled;
- (BOOL)accountIsSubscription;
- (BOOL)accountIsTrial;
- (BOOL)accountIsSubscribedToNewsletter;
- (NSInteger)accountMaximumAllowedTracks;
- (NSDate *)accountExpireTime;

// media library
- (void)fetchAllTracksWithDelegate:(id<GoogleMusicLibraryParserDelegate>)delegate;

@end
