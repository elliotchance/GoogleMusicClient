#import "Test.h"
#import "GoogleMusicClient.h"

@interface GoogleMusicClientTestCase : XCTestCase <GoogleMusicClientDelegate>

@property GoogleMusicClient *client;
@property NSString *email;
@property NSString *password;

- (void)login;

@end
