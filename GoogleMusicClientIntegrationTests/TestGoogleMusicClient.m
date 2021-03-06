#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Test.h"

@interface TestGoogleMusicClient : GoogleMusicClientTestCase

@end

@implementation TestGoogleMusicClient

- (void)setUp
{
    [super setUp];
    
    NSString *settingsPath = @"Settings.json";
    if(![[NSFileManager defaultManager] fileExistsAtPath:settingsPath]) {
        XCTFail("%@ does not exist. Create it with the format {\"email\":\"foo\",\"password\":\"bar\"}.", settingsPath);
    }
    
    NSMutableDictionary *settings = [NSMutableDictionary mutableDictionaryWithJsonFile:settingsPath];
    self.email = [settings valueForKey:@"email"];
    self.password = [settings valueForKey:@"password"];
    self.client = [[GoogleMusicClient alloc] init];
    
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
