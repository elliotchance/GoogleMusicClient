#import "Test.h"
#import "Track.h"
#import "StreamURLForTrack.h"

#define NOT_USED nil
#define TRACK_ID @"f6fd575f-b2fc-32bb-afb2-083bfdc88f6b"

@interface TestStreamURLForTrack : XCTestCase

- (NSData *)mockedResponseForDownloadUrl;
- (id)downloaderMockThatFetches:(NSData *)data;

@end

@implementation TestStreamURLForTrack

- (void)testInitialiserSetsItsOwnDownloader
{
    StreamURLForTrack *service = [[StreamURLForTrack alloc] initWithTrackId:TRACK_ID];
    assertThat(service.downloader, instanceOf([Downloader class]));
}

- (void)testInitialiserUsesTheTrackIdProvided
{
    StreamURLForTrack *service = [[StreamURLForTrack alloc] initWithTrackId:TRACK_ID];
    assertThat(service.trackId, equalTo(TRACK_ID));
}

- (void)testCanGenerateStreamUrl
{
    StreamURLForTrack *service = [[StreamURLForTrack alloc] initWithTrackId:TRACK_ID];
    service.downloader = [self downloaderMockThatFetches:[self mockedResponseForDownloadUrl]];
    
    assertThat([service fetchStreamURL], hasDescription(@"http://t.doc-0-0-sj.sj.googleusercontent.com/stream?bla"));
}

- (void)testParameterMjckContainsTheTrackIdIfTrackIdStartsWithTheLetterT
{
    StreamURLForTrack *service = [[StreamURLForTrack alloc] initWithTrackId:@"T123"];
    assertThat([service parametersForStreamUrlUsingSalt:NOT_USED signature:NOT_USED],
               hasEntry(@"mjck", @"T123"));
}

- (void)testParameterSongidContainsTheTrackIdIfTrackIdDoesNotStartWithTheLetterT
{
    StreamURLForTrack *service = [[StreamURLForTrack alloc] initWithTrackId:@"A123"];
    assertThat([service parametersForStreamUrlUsingSalt:NOT_USED signature:NOT_USED],
               hasEntry(@"songid", @"A123"));
}

- (void)testParameterSongidDoesNotExistIfTrackIdStartsWithTheLetterT
{
    StreamURLForTrack *service = [[StreamURLForTrack alloc] initWithTrackId:@"T123"];
    assertThat([service parametersForStreamUrlUsingSalt:NOT_USED signature:NOT_USED], lacksKey(@"songid"));
}

- (void)testParameterMjckDoesNotExistIfTrackIdDoesNotStartWithTheLetterT
{
    StreamURLForTrack *service = [[StreamURLForTrack alloc] initWithTrackId:@"A123"];
    assertThat([service parametersForStreamUrlUsingSalt:NOT_USED signature:NOT_USED], lacksKey(@"mjck"));
}

- (void)testBaseURLPointsToGooglePlay
{
    StreamURLForTrack *service = [[StreamURLForTrack alloc] initWithTrackId:TRACK_ID];
    assertThat([service baseURL], hasDescription(@"https://play.google.com/music/play"));
}

- (void)testAccessKeyIsCorrect
{
    StreamURLForTrack *service = [[StreamURLForTrack alloc] initWithTrackId:TRACK_ID];
    assertThat([service accessKey], equalTo(@"27f7313e-f75d-445a-ac99-56386a5fe879"));
}

- (void)testRandomSaltIs12Characters
{
    StreamURLForTrack *service = [[StreamURLForTrack alloc] initWithTrackId:TRACK_ID];
    assertThatInteger([[service randomSalt] length], equalToInteger(12));
}

- (NSData *)mockedResponseForDownloadUrl
{
    NSString *json = @"{\"tier\":2,\"url\":\"http://t.doc-0-0-sj.sj.googleusercontent.com/stream?bla\"}";
    return [json dataUsingEncoding:NSUTF8StringEncoding];
}

- (id)downloaderMockThatFetches:(NSData *)data
{
    Downloader *downloader = [Downloader new];
    id downloaderMock = [OCMockObject partialMockForObject:downloader];
    [[[downloaderMock stub] andReturn:data] fetchURL:OCMOCK_ANY];
    return downloaderMock;
}

@end
