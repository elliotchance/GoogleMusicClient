#import "Test.h"
#import "GoogleMusicClient.h"
#import "GoogleMusicClientProtocol.h"
#import "CollectionFactory.h"
#import "GoogleMusicClientTestCase.h"
#import "Track.h"

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
