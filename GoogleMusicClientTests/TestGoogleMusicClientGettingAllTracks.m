#import "Test.h"

@interface TestGoogleMusicClientGettingAllTracks : GoogleMusicClientTestCase

@property id clientMock;

@end

@implementation TestGoogleMusicClientGettingAllTracks

- (void)setUp
{
    [super setUp];
    GoogleMusicClient *client = [GoogleMusicClient new];
    self.clientMock = [OCMockObject partialMockForObject:client];
    [[self.clientMock expect] requestService:@"streamingloadalltracks" completionHandler:OCMOCK_ANY];
    [[[self.clientMock expect] andForwardToRealObject] fetchAllTracksWithDelegate:OCMOCK_ANY];
}

- (void)tearDown
{
    [self.clientMock verify];
    [super tearDown];
}

- (void)testGettingAllTracksWillMakeRequestToGoogleMusic
{
    [self.clientMock fetchAllTracksWithDelegate:nil];
    
}

@end
