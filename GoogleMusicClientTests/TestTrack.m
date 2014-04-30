#import "Test.h"

@interface TestTrack : XCTestCase

@property Track *track;

@end

@implementation TestTrack

- (void)setUp
{
    self.track = [[Track alloc] initWithTrackId:@"25ededda-95fc-3ca6-9c77-3b43ec6836ee"];
}

- (void)testCanUpdatePropertyViaKey
{
    [self.track setValue:@"abc" forKey:@"title"];
    assertThat(self.track.title, equalTo(@"abc"));
}

- (void)testCanSetAndRetrievePropertyViaKey
{
    [self.track setValue:@"abc" forKey:@"title"];
    assertThat([self.track valueForKey:@"title"], equalTo(@"abc"));
}

- (void)testCanRetrievePropertyViaKey
{
    self.track.title = @"abc";
    assertThat([self.track valueForKey:@"title"], equalTo(@"abc"));
}

- (void)testRetrievingPropertyViaKeyThatDoesntExistThrowsException
{
    XCTAssertThrows([self.track setValue:@"abc" forKey:@"noSuchKey"]);
}

- (void)testUpdatingPropertyViaKeyWithWrongTypeThrowsException
{
    XCTAssertThrows([self.track setValue:@"test" forKey:@"trackNumber"]);
}

- (void)testDescriptionRendersLikeADictionary
{
    assertThat([self.track description], containsString(@"title = \"\";"));
}

- (void)testCanGenerateAttributeTitleFromAttributeName
{
    assertThat([Track attributeTitleFromName:@"title"], equalTo(@"Title"));
}

- (void)testCanGenerateAttributeTitleFromAttributeNameWillConvertCapitalsToSpaces
{
    assertThat([Track attributeTitleFromName:@"albumArtUrl"], equalTo(@"Album Art Url"));
}

- (void)testCanGetAnArrayOfAllAttributes
{
    assertThat([Track attributes], instanceOf([NSDictionary class]));
}

- (void)testAllAttributesContainsTrackId
{
    assertThat([Track attributes], hasEntry(@"albumArtist", @"Album Artist"));
}

- (void)testArchivedValueForTitleIsTheSame
{
    self.track.title = @"something";
    assertThat([self.track archiveValueForKey:@"title"], equalTo(@"something"));
}

- (void)testArchivedValueForIntegerValue
{
    self.track.trackNumber = 123;
    assertThat([self.track archiveValueForKey:@"trackNumber"], equalTo(@123));
}

- (void)testArchivedValueForArrayValue
{
    self.track.origin = [NSArray arrayWithObjects:@"abc", @"def", nil];
    assertThat([self.track archiveValueForKey:@"origin"], equalTo(@"[\"abc\",\"def\"]"));
}

- (void)testUpdatingPropertyViaKeyWithNilThrowsException
{
    XCTAssertThrows([self.track setValue:nil forKey:@"title"]);
}

- (void)testCanRecogniseValidTrackId
{
    assertTrue([Track validateTrackId:@"c723c295-b8f5-34d9-89ff-60a8f232abb5"]);
}

- (void)testCanRecogniseInvalidTrackId
{
    assertFalse([Track validateTrackId:@"123"]);
}

- (void)testWillPreventAnInvalidTrackIdFromBeingAssigned
{
    XCTAssertThrows([self.track setTrackId:@"123"]);
}

- (void)testDefaultInitializerThrowsException
{
    XCTAssertThrows([Track new]);
}

- (void)testSettingArchiveValueWithAnOriginOfNilIsTurnedIntoAnArray
{
    [self.track setArchiveValue:@"" forKey:@"origin"];
    assertThat(self.track.origin, hasCountOf(0));
}

- (void)testHasLastSynchronizedProperty
{
    assertTrue([self.track respondsToSelector:@selector(lastSynchronized)]);
}

- (void)testLastSynchronizedIsNowIfNotSet
{
    // We must compare on -description because of the fraction of a second that is different in the dates between when
    // it was initialised and now.
    assertThat([self.track lastSynchronized], hasDescription([[NSDate date] description]));
}

- (void)testSettingRatingToAbove5ThrowsAnInvalidArgumentException
{
    XCTAssertThrowsSpecificNamed(self.track.rating = 6, NSException, NSInvalidArgumentException);
}

- (void)testUnknownRatingHasTheSpecialValueOfZero
{
    assertThatInteger(UnknownRating, equalToInteger(0));
}

- (void)testCanFetchStreamUrl
{
    id serviceMock = [OCMockObject mockForClass:[StreamURLForTrack class]];
    [[[serviceMock stub] andReturn:@"123"] fetchStreamURL];
    assertThat([serviceMock fetchStreamURL], hasDescription(@"123"));
}

@end
