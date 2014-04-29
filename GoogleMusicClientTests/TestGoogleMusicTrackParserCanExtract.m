#import "Test.h"
#import "GoogleMusicTrackParser.h"
#import "Track.h"
#import "CollectionFactory.h"

@interface TestGoogleMusicTrackParserCanExtract : XCTestCase

@property Track *track;

@end

@implementation TestGoogleMusicTrackParserCanExtract

- (void)setUp
{
    NSArray *raw = [NSArray arrayWithJsonString:@"[\"f6fd575f-b2fc-32bb-afb2-083bfdc88f6b\",\"Rise Above the World (Ultimate remix)\",\"//lh6.googleusercontent.com/EaqMmJkbjOPcNdSXiPkEFbLLe-OJy00iHJ6CFIncc6VJmiOsK0rA2Nh8pQiCAA\",\"Dimension \\u0026 Moonsouls\",\"2013-07-11: A State of Trance #621\",\"Armin van Buuren\",null,null,null,null,\"Unknown Composer\",\"Trance\",null,223000,22,32,1,1,2013,0,null,null,123,3,1388308233895046,1388422813001548,null,\"Ttsrf2gs4nojn2tlglvw6xvczby\",null,2,\"My comment\",null,null,\"A5m6osk6qd7a6rz3gpefuehs77y\",256,1388308776865000,\"//lh3.googleusercontent.com/RsW7yY7R90IWtuQsUnneY2xQbjQ3nIJji7fjxlwMPdNX6COql88v2v8FRWjvmXI0X1_Pg6dgMQ\",null,null,[]]"];
    self.track = [GoogleMusicTrackParser trackFromArray:raw];
}

- (void)testTitle
{
    assertThat(self.track.title, equalTo(@"Rise Above the World (Ultimate remix)"));
}

- (void)testAlbum
{
    assertThat(self.track.album, equalTo(@"2013-07-11: A State of Trance #621"));
}

- (void)testAlbumArtUrl
{
    assertThat(self.track.albumArtUrl, equalTo(@"//lh6.googleusercontent.com/EaqMmJkbjOPcNdSXiPkEFbLLe-OJy00iHJ6CFIncc6VJmiOsK0rA2Nh8pQiCAA"));
}

- (void)testAlbumArtist
{
    assertThat(self.track.albumArtist, equalTo(@"Armin van Buuren"));
}

- (void)testArtist
{
    assertThat(self.track.artist, equalTo(@"Dimension & Moonsouls"));
}

- (void)testTrackId
{
    assertThat(self.track.trackId, equalTo(@"f6fd575f-b2fc-32bb-afb2-083bfdc88f6b"));
}

- (void)testGenre
{
    assertThat(self.track.genre, equalTo(@"Trance"));
}

- (void)testBitRate
{
    assertThatInteger(self.track.bitRate, equalToInteger(256));
}

- (void)testCreationDate
{
    assertThat(self.track.creationDate, equalTo([NSDate dateWithString:@"2013-12-29 09:10:33 +0000"]));
}

- (void)testYear
{
    assertThatInteger(self.track.year, equalToInteger(2013));
}

- (void)testTrackNumber
{
    assertThatInteger(self.track.trackNumber, equalToInteger(22));
}

- (void)testTrackTotal
{
    assertThatInteger(self.track.trackTotal, equalToInteger(32));
}

- (void)testDiscNumber
{
    assertThatInteger(self.track.discNumber, equalToInteger(1));
}

- (void)testDiscTotal
{
    assertThatInteger(self.track.discTotal, equalToInteger(1));
}

- (void)testType
{
    assertThatInteger(self.track.type, equalToInteger(TrackTypeUploadedNotMatched));
}

- (void)testDuration
{
    assertThatInteger(self.track.duration, equalToInteger(223000));
}

- (void)testOrigin
{
    assertThat(self.track.origin, hasCountOf(0));
}

- (void)testComposer
{
    assertThat(self.track.composer, equalTo(@"Unknown Composer"));
}

- (void)testPlayCount
{
    assertThatInteger(self.track.playCount, equalToInteger(123));
}

- (void)testRating
{
    assertThatInteger(self.track.rating, equalToInteger(3));
}

- (void)testComment
{
    assertThat(self.track.comment, equalTo(@"My comment"));
}

- (void)testLargeAlbumArtUrl
{
    assertThat(self.track.largeAlbumArtUrl, equalTo(@"//lh3.googleusercontent.com/RsW7yY7R90IWtuQsUnneY2xQbjQ3nIJji7fjxlwMPdNX6COql88v2v8FRWjvmXI0X1_Pg6dgMQ"));
}

- (void)testModificationDate
{
    assertThat(self.track.modificationDate, equalTo([NSDate dateWithString:@"2013-12-30 17:00:13 +0000"]));
}

- (void)testLastPlayedDate
{
    assertThat(self.track.lastPlayedDate, equalTo([NSDate dateWithString:@"2013-12-29 09:19:36 +0000"]));
}

- (void)testStoreId
{
    assertThat(self.track.storeId, equalTo(@"Ttsrf2gs4nojn2tlglvw6xvczby"));
}

- (void)testMatchedId
{
    assertThat(self.track.matchedId, equalTo(@"A5m6osk6qd7a6rz3gpefuehs77y"));
}

@end
