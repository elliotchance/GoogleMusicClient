#import "Test.h"
#import "GoogleMusicClientTestCase.h"
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

- (void)login
{
    [self.client loginWithEmail:self.email password:self.password delegate:self];
    [self waitForTimeout:[GoogleMusicClient maximumWaitTimeForRequest]];
}

@end
