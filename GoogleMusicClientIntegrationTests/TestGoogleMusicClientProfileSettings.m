#import "Test.h"
#import "Test.h"

static id<GoogleMusicClientProtocol> client = nil;

@interface TestGoogleMusicClientSettings : GoogleMusicClientTestCase

@end

@implementation TestGoogleMusicClientSettings

- (void)setUp
{
    if(nil == client) {
        [super setUp];
        [self login];
        client = self.client;
    }
    else {
        self.client = client;
    }
}

- (void)testHasDesktopNotifications
{
    [self.client desktopNotications];
}

- (void)testHasHTML5Audio
{
    [self.client useHTML5Audio];
}

- (void)testHas5StarRatings
{
    [self.client use5StarRatings];
}

- (void)testHasViewTrackComments
{
    [self.client viewTrackComments];
}

- (void)testHasChromecastFireplaceVisualizer
{
    [self.client chromecastFireplaceVisualizer];
}

- (void)testAccountIsCanceled
{
    assertFalse([self.client accountIsCanceled]);
}

- (void)testAccountIsSubscription
{
    [self.client accountIsSubscription];
}

- (void)testAccountIsInTrial
{
    assertFalse([self.client accountIsTrial]);
}

- (void)testAccountIsSubscribedToNewsletter
{
    [self.client accountIsSubscribedToNewsletter];
}

- (void)testAccountMaximumAllowedTracks
{
    assertThatInt([self.client accountMaximumAllowedTracks], equalToInt(20000));
}

- (void)testAccountExpireTime
{
    [self.client accountExpireTime];
}

- (void)testAccountExpireTimeIsInTheFuture
{
    NSDate *d = [self.client accountExpireTime];
    assertTrue([d isGreaterThan:[NSDate date]]);
}

@end
