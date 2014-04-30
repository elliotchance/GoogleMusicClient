#import "Test.h"

@interface TestGoogleMusicClient : GoogleMusicClientTestCase

@end

@implementation TestGoogleMusicClient

- (void)testFirstStageIsWaitingOnAuthToken
{
    assertThatInt(((GoogleMusicClient *)self.client).stage, equalToInt(GoogleMusicClientStageWaitingOnAuthToken));
}

- (void)testIsNotConnectedBeforeLoginIsPerformed
{
    assertFalse([self.client isLoggedIn]);
}

@end
