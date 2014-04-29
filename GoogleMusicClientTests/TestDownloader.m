#import <XCTest/XCTest.h>
#import "Downloader.h"
#import "Test.h"

#define NOT_USED nil

@interface TestDownloader : XCTestCase

@property id downloaderMock;

@end

@implementation TestDownloader

- (void)setUp
{
    self.downloaderMock = [OCMockObject partialMockForObject:[[Downloader alloc] init]];
}

- (void)testCanReturnDictionaryFromJsonFetch
{
    [[[self.downloaderMock stub] andReturn:[@"{\"a\":123}" dataUsingEncoding:NSUTF8StringEncoding]] fetchURL:OCMOCK_ANY];
    NSDictionary *dictionary = [self.downloaderMock fetchDictionaryFromJSONURL:NOT_USED];
    assertThat(dictionary, hasEntry(@"a", @123));
}

@end
