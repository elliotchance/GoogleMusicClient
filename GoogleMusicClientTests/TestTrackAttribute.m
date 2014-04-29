#import "Test.h"
#import "Track.h"
#import "GoogleMusicTrackParser.h"
#import "CollectionFactory.h"

@interface TestTrackAttribute : XCTestCase

@property Track *track;

@end

@implementation TestTrackAttribute

- (void)setUp
{
    self.track = [[Track alloc] initWithTrackId:@"25ededda-95fc-3ca6-9c77-3b43ec6836ee"];
}

- (void)testTitleIsBlankIfNotSet
{
    assertThat(self.track.title, emptyString());
}

- (void)testTrackIdIsSet
{
    assertThat(self.track.trackId, equalTo(@"25ededda-95fc-3ca6-9c77-3b43ec6836ee"));
}

- (void)testAlbumIsBlankIfNotSet
{
    assertThat(self.track.album, emptyString());
}

- (void)testAlbumArtUrlIsBlankIfNotSet
{
    assertThat(self.track.albumArtUrl, emptyString());
}

- (void)testAlbumArtistIsBlankIfNotSet
{
    assertThat(self.track.albumArtist, emptyString());
}

- (void)testArtistIsBlankIfNotSet
{
    assertThat(self.track.artist, emptyString());
}

- (void)testBitRateIsUnknownIfNotSet
{
    assertThatInteger(self.track.bitRate, equalToInteger(UnknownBitRate));
}

- (void)testGenreIsBlankIfNotSet
{
    assertThat(self.track.genre, emptyString());
}

- (void)testCreationDateIsNowIfNotSet
{
    // We must compare on -description because of the fraction of a second that is different in the dates between when
    // it was initialised and now.
    assertThat(self.track.creationDate, hasDescription([[NSDate date] description]));
}

- (void)testYearIsUnknownIfNotSet
{
    assertThatInteger(self.track.year, equalToInteger(UnknownYear));
}

- (void)testTrackNumberIsUnknownIfNotSet
{
    assertThatInteger(self.track.trackNumber, equalToInteger(UnknownTrackNumber));
}

- (void)testTrackTotalIsUnknownIfNotSet
{
    assertThatInteger(self.track.trackTotal, equalToInteger(UnknownTrackTotal));
}

- (void)testDiscNumberIsUnknownIfNotSet
{
    assertThatInteger(self.track.discNumber, equalToInteger(UnknownDiscNumber));
}

- (void)testDiscTotalIsUnknownIfNotSet
{
    assertThatInteger(self.track.discTotal, equalToInteger(UnknownDiscTotal));
}

- (void)testTypeIsFreeOrPurchasedIfNotSet
{
    assertThatInteger(self.track.type, equalToInteger(TrackTypeFreeOrPurchased));
}

- (void)testDurationIsUnknownIfNotSet
{
    assertThatInteger(self.track.duration, equalToInteger(UnknownDuration));
}

- (void)testOriginHasNoElementsIfNotSet
{
    assertThat(self.track.origin, hasCountOf(0));
}

- (void)testComposerIsBlankIfNotSet
{
    assertThat(self.track.composer, emptyString());
}

- (void)testPlayCountIsZeroIfNotSet
{
    assertThatInteger(self.track.playCount, equalToInteger(0));
}

- (void)testRatingIsUnknownIfNotSet
{
    assertThatInteger(self.track.rating, equalToInteger(UnknownRating));
}

- (void)testCommentIsBlankIfNotSet
{
    assertThat(self.track.comment, emptyString());
}

- (void)testLargeAlbumArtUrlIsBlankIfNotSet
{
    assertThat(self.track.largeAlbumArtUrl, emptyString());
}

- (void)testModificationDateIsNowIfNotSet
{
    // We must compare on -description because of the fraction of a second that is different in the dates between when
    // it was initialised and now.
    assertThat(self.track.modificationDate, hasDescription([[NSDate date] description]));
}

- (void)testLastPlayedDateIsNowIfNotSet
{
    // We must compare on -description because of the fraction of a second that is different in the dates between when
    // it was initialised and now.
    assertThat(self.track.lastPlayedDate, hasDescription([[NSDate date] description]));
}

- (void)testStoreIdIsBlankIfNotSet
{
    assertThat(self.track.storeId, emptyString());
}

- (void)testMatchedIdIsBlankIfNotSet
{
    assertThat(self.track.matchedId, emptyString());
}

@end
