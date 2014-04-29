#import "Test.h"
#import "Track.h"
#import "StreamURLForTrack.h"

#define NOT_USED nil
#define TRACK_ID @"f6fd575f-b2fc-32bb-afb2-083bfdc88f6b"

@interface TestStreamURLForTrackParameters : XCTestCase

@property StreamURLForTrack *service;

@end

@implementation TestStreamURLForTrackParameters

- (void)setUp
{
    self.service = [[StreamURLForTrack alloc] initWithTrackId:TRACK_ID];
}

- (void)testForStreamUrlWillSetUToZero
{
    assertThat([self.service parametersForStreamUrlUsingSalt:NOT_USED signature:NOT_USED],
               hasEntry(@"u", @0));
}

- (void)testForStreamUrlWillSetPtToE
{
    assertThat([self.service parametersForStreamUrlUsingSalt:NOT_USED signature:NOT_USED],
               hasEntry(@"pt", @"e"));
}

- (void)testForStreamUrlWillSetTheSaltToTheValueProvided
{
    assertThat([self.service parametersForStreamUrlUsingSalt:@"mysalt" signature:NOT_USED],
               hasEntry(@"slt", @"mysalt"));
}

- (void)testForStreamUrlWillSetTheSignatureToTheValueProvided
{
    assertThat([self.service parametersForStreamUrlUsingSalt:NOT_USED signature:@"mysig"],
               hasEntry(@"sig", @"mysig"));
}

@end
