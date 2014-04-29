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

- (void)setUp
{
    [super setUp];
    [self login];
}

- (void)testSettingsCanBeDownloaded
{
    NSDictionary *googleMusicSettings = [self.client profileSettings];
    assertThat(googleMusicSettings, hasKey(@"settings"));
}

- (void)testInvalidLabProfileSettingNameThrowsException
{
    GoogleMusicClient *client = (GoogleMusicClient *)self.client;
    XCTAssertThrowsSpecificNamed([client labProfileSetting:@"Bla Bla"], NSException, @"NoSuchProfileSetting");
}

- (void)testCanConnectToGoogleMusicSuccessfully
{
    assertTrue([self.client isLoggedIn]);
}

- (void)testWillNotReportAsLoggedInIfTheCredentialsAreWrong
{
    [self.client loginWithEmail:self.email password:@"wrong_password" delegate:self];
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
