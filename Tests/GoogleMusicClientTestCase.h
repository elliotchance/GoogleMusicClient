#import "Test.h"
#import "GoogleMusicClient.h"

@interface GoogleMusicClientTestCase : XCTestCase <GoogleMusicClientDelegate>

@property id<GoogleMusicClientProtocol> client;
@property NSString *email;
@property NSString *password;

- (void)login;

@end
