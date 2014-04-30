#import "Test.h"

@interface TestGoogleMusicTrackParser : XCTestCase

@end

@implementation TestGoogleMusicTrackParser

- (void)testWillGenerateSongInformationFromRawArray
{
    NSArray *raw = [NSArray arrayWithJsonString:@"[\"f6fd575f-b2fc-32bb-afb2-083bfdc88f6b\",\"Rise Above the World (Ultimate remix)\",\"//lh6.googleusercontent.com/EaqMmJkbjOPcNdSXiPkEFbLLe-OJy00iHJ6CFIncc6VJmiOsK0rA2Nh8pQiCAA\",\"Dimension \\u0026 Moonsouls\",\"2013-07-11: A State of Trance #621\",\"Armin van Buuren\",null,null,null,null,\"Unknown Composer\",\"Trance\",null,223000,22,32,1,1,2013,0,null,null,0,0,1388308233895046,1388422813001548,null,\"Ttsrf2gs4nojn2tlglvw6xvczby\",null,2,\"\",null,null,\"A5m6osk6qd7a6rz3gpefuehs77y\",256,1388308776865000,\"//lh3.googleusercontent.com/RsW7yY7R90IWtuQsUnneY2xQbjQ3nIJji7fjxlwMPdNX6COql88v2v8FRWjvmXI0X1_Pg6dgMQ\",null,null,[]]"];
    Track *track = [GoogleMusicTrackParser trackFromArray:raw];
    assertThat(track, notNilValue());
}

- (void)testStringPropertyOfArrayWillReturnBlankIfObjectIsNotAString
{
    NSArray *array = [NSArray arrayWithObjects:@123, nil];
    assertThat([GoogleMusicTrackParser stringProperty:0 of:array], equalTo(@""));
}

- (void)testStringPropertyOfArrayWillReturnBlankIfOutOfBounds
{
    NSArray *array = [NSArray arrayWithObjects:@123, nil];
    assertThat([GoogleMusicTrackParser stringProperty:1 of:array], equalTo(@""));
}

- (void)testStringPropertyOfArrayWillReturnBlankIfIsNull
{
    NSArray *array = [NSArray arrayWithObjects:[NSNull new], nil];
    assertThat([GoogleMusicTrackParser stringProperty:0 of:array], equalTo(@""));
}

- (void)testIntegerPropertyOfArrayWillReturnRespectiveIntegerValue
{
    NSArray *array = [NSArray arrayWithObjects:@"123", nil];
    assertThatInteger([GoogleMusicTrackParser integerProperty:0 of:array defaultsTo:100], equalToInteger(123));
}

- (void)testIntegerPropertyOfArrayWillReturnRespectiveIntegerValueOfAnotherNumber
{
    NSArray *array = [NSArray arrayWithObjects:@123, nil];
    assertThatInteger([GoogleMusicTrackParser integerProperty:0 of:array defaultsTo:100], equalToInteger(123));
}

- (void)testIntegerPropertyOfArrayWillReturnDefaultValueForNull
{
    NSArray *array = [NSArray arrayWithObjects:[NSNull new], nil];
    assertThatInteger([GoogleMusicTrackParser integerProperty:0 of:array defaultsTo:100], equalToInteger(100));
}

- (void)testIntegerPropertyOfArrayWillReturnDefaultValueForStringValue
{
    NSArray *array = [NSArray arrayWithObjects:@"0bla", nil];
    assertThatInteger([GoogleMusicTrackParser integerProperty:0 of:array defaultsTo:100], equalToInteger(100));
}

- (void)testIntegerPropertyOfArrayWillReturnDefaultValueForIndexOutOfBounds
{
    NSArray *array = [NSArray arrayWithObjects:@123, nil];
    assertThatInteger([GoogleMusicTrackParser integerProperty:1 of:array defaultsTo:100], equalToInteger(100));
}

- (void)testIntegerValueWillReturnRespectiveIntegerValue
{
    assertThatInteger([GoogleMusicTrackParser integerValueOf:@"123" defaultsTo:100], equalToInteger(123));
}

- (void)testIntegerValueWillReturnRespectiveIntegerValueOfAnotherNumber
{
    assertThatInteger([GoogleMusicTrackParser integerValueOf:[@123 description] defaultsTo:100], equalToInteger(123));
}

- (void)testIntegerValueOfArrayWillReturnDefaultValueForNull
{
    assertThatInteger([GoogleMusicTrackParser integerValueOf:[[NSNull new] description]
                                                  defaultsTo:100], equalToInteger(100));
}

- (void)testIntegerValueWillReturnDefaultValueForStringValue
{
    assertThatInteger([GoogleMusicTrackParser integerValueOf:@"0bla" defaultsTo:100], equalToInteger(100));
}

@end
