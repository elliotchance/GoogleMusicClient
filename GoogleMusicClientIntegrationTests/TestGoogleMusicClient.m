#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Test.h"
#import "GoogleMusicClient.h"
#import "GoogleMusicClientProtocol.h"
#import "XCTestCase+AsyncTesting.h"
#import "CollectionFactory.h"
#import "GoogleMusicClientTestCase.h"

@interface TestGoogleMusicClient : GoogleMusicClientTestCase

@end

@implementation TestGoogleMusicClient

- (void)testCanConnectToGoogleMusicSuccessfully
{
    [self login];
    assertTrue([self.client isLoggedIn]);
}

- (void)testWillNotReportAsLoggedInIfTheCredentialsAreWrong
{
    NSString *email = [[[self.client settings] valueForKeyPath:Settings_login_email] description];
    NSString *password = @"wrong_password";
    [self.client loginWithEmail:email password:password delegate:self];
    [self waitForTimeout:[GoogleMusicClient maximumWaitTimeForRequest]];
    
    assertFalse([self.client isLoggedIn]);
}

- (void)testCanGetAllTracks
{
    id libraryMock = [OCMockObject niceMockForClass:[GoogleMusicLibraryParser class]];
    id clientMock = [OCMockObject partialMockForObject:self.client];
    __block TestGoogleMusicClient *this = self;
    [[[[clientMock stub] andDo:^(NSInvocation *invocation) {
        [this notify:XCTAsyncTestCaseStatusSucceeded];
    }] andReturn:libraryMock] libraryParserWithHTML:OCMOCK_ANY];
    
    [self login];
    [clientMock fetchAllTracksWithDelegate:nil];
    [self waitForTimeout:10000];
}

@end
