#import "Test.h"
#import "GoogleMusicClientTestCase.h"
#import "CollectionFactory.h"
#import "GoogleMusicClientDelegate.h"
#import "XCTestCase+AsyncTesting.h"

@implementation GoogleMusicClientTestCase

- (void)loginDidSucceed
{
    [self notify:XCTAsyncTestCaseStatusSucceeded];
}

- (void)loginDidFail
{
    [self notify:XCTAsyncTestCaseStatusFailed];
}

- (void)doesNotHaveInternet
{
    [self notify:XCTAsyncTestCaseStatusFailed];
}

- (void)libraryDidFinishSynchronizing
{
}

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
}

- (void)login
{
    [self.client loginWithEmail:self.email password:self.password delegate:self];
    [self waitForTimeout:[GoogleMusicClient maximumWaitTimeForRequest]];
}

@end
