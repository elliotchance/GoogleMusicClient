#import "Test.h"

extern NSMutableArray *GoogleMusicLibraryParser_tracks;

@interface TestGoogleMusicLibraryParser : XCTestCase

- (NSString *)htmlForParserWithOneSong;
- (NSString *)jsonForParserWithOneSong;
- (id)mockForSongDelegateThatNotifiesSuccessOnDidReceiveSongJsonTimes:(NSUInteger)times;
- (GoogleMusicLibraryParser *)parserWithSongDelegate:(id)delegate;
- (GoogleMusicLibraryParser *)parserThatDoesntNeedHTML;

@end

@implementation TestGoogleMusicLibraryParser

- (void)testWillFireDidReceiveSongJsonOnASingleSong
{
    id delegateMock = [self mockForSongDelegateThatNotifiesSuccessOnDidReceiveSongJsonTimes:1];
    GoogleMusicLibraryParser *parser = [self parserWithSongDelegate:delegateMock];
    
    [parser execute];
    
    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:1];
    [delegateMock verify];
}

- (void)testWillFireDidReceiveSongJsonMultipleTimesOnMultipleSlatProcess
{
    id delegateMock = [self mockForSongDelegateThatNotifiesSuccessOnDidReceiveSongJsonTimes:2];
    NSString *html = [NSString stringWithFormat:@"%@%@", [self htmlForParserWithOneSong],
                      [self htmlForParserWithOneSong]];
    GoogleMusicLibraryParser *parser = [[GoogleMusicLibraryParser alloc] initWithHTML:html];
    parser.songDelegate = delegateMock;
    
    [parser execute];
    
    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:1];
    [delegateMock verify];
}

- (void)testWillFireDidFinishReceivingTracksAfterFrameIsLoaded
{
    id delegateMock = [OCMockObject niceMockForProtocol:@protocol(GoogleMusicLibraryParserDelegate)];
    [[delegateMock expect] didFinishReceivingTracks:OCMOCK_ANY];
    
    GoogleMusicLibraryParser *p = [self parserWithSongDelegate:nil];
    p.songDelegate = p;
    p.delegate = delegateMock;
    [p webView:nil didFinishLoadForFrame:nil];
    [self waitForTimeout:1];
    
    [delegateMock verify];
}

- (void)testDidReceiveTrackJsonWillAddTrackToTracks
{
    id tracksMock = [OCMockObject mockForClass:[NSMutableArray class]];
    [[tracksMock expect] addObject:OCMOCK_ANY];
    GoogleMusicLibraryParser *parser = [self parserThatDoesntNeedHTML];
    GoogleMusicLibraryParser_tracks = tracksMock;
    
    [parser didReceiveTrackJson:@"[\"f6fd575f-b2fc-32bb-afb2-083bfdc88f6b\",\"Rise Above the World (Ultimate remix)\",\"//lh6.googleusercontent.com/EaqMmJkbjOPcNdSXiPkEFbLLe-OJy00iHJ6CFIncc6VJmiOsK0rA2Nh8pQiCAA\",\"Dimension \\u0026 Moonsouls\",\"2013-07-11: A State of Trance #621\",\"Armin van Buuren\",null,null,null,null,\"\",\"Trance\",null,223000,22,32,1,1,2013,0,null,null,0,0,1388308233895046,1388422813001548,null,\"Ttsrf2gs4nojn2tlglvw6xvczby\",null,2,\"\",null,null,\"A5m6osk6qd7a6rz3gpefuehs77y\",256,1388308776865000,\"//lh3.googleusercontent.com/RsW7yY7R90IWtuQsUnneY2xQbjQ3nIJji7fjxlwMPdNX6COql88v2v8FRWjvmXI0X1_Pg6dgMQ\",null,null,[]]"];
    
    [tracksMock verify];
}

- (void)testIsAllowedToHaveANilParserDelegate
{
    GoogleMusicLibraryParser *parser = [self parserThatDoesntNeedHTML];
    parser.delegate = nil;
    [parser webView:nil didFinishLoadForFrame:nil];
}

- (void)testInitUsesSelfAsSongDelegate
{
    GoogleMusicLibraryParser *parser = [self parserThatDoesntNeedHTML];
    assertThat(parser.songDelegate, sameInstance(parser));
}

- (void)testInitSetsDelegateToNil
{
    GoogleMusicLibraryParser *parser = [self parserThatDoesntNeedHTML];
    assertThat(parser.delegate, nilValue());
}

- (void)testDidFinishLoadForFrameWillImmediatlyReturnIfTheWebViewIsStillLoading
{
    id webViewMock = [OCMockObject mockForClass:[WebView class]];
    [[[webViewMock expect] andReturnValue:@YES] isLoading];
    
    GoogleMusicLibraryParser *parser = [self parserThatDoesntNeedHTML];
    [parser webView:webViewMock didFinishLoadForFrame:nil];
    
    [webViewMock verify];
}

- (id)mockForSongDelegateThatNotifiesSuccessOnDidReceiveSongJsonTimes:(NSUInteger)times
{
    id delegateMock = [OCMockObject niceMockForProtocol:@protocol(GoogleMusicLibraryParserSongDelegate)];
    TestGoogleMusicLibraryParser *this = self;
    for(NSUInteger i = 0; i < times - 1; ++i) {
        [[[delegateMock expect] andDo:^(NSInvocation *invocation) {
            // do nothing
        }] didReceiveTrackJson:OCMOCK_ANY];
    }
    [[[delegateMock expect] andDo:^(NSInvocation *invocation) {
        [this notify:XCTAsyncTestCaseStatusSucceeded];
    }] didReceiveTrackJson:OCMOCK_ANY];
    return delegateMock;
}

- (NSString *)jsonForParserWithOneSong
{
    return @"[\"f6fd575f-b2fc-32bb-afb2-083bfdc88f6b\",\"Rise Above the World (Ultimate remix)\",\"//lh6.googleusercontent.com/EaqMmJkbjOPcNdSXiPkEFbLLe-OJy00iHJ6CFIncc6VJmiOsK0rA2Nh8pQiCAA\",\"Dimension \\u0026 Moonsouls\",\"2013-07-11: A State of Trance #621\",\"Armin van Buuren\",,,,,\"\",\"Trance\",,223000,22,32,1,1,2013,0,,,0,0,1388308233895046,1388422813001548,,\"Ttsrf2gs4nojn2tlglvw6xvczby\",,2,\"\",,,\"A5m6osk6qd7a6rz3gpefuehs77y\",256,1388308776865000,\"//lh3.googleusercontent.com/RsW7yY7R90IWtuQsUnneY2xQbjQ3nIJji7fjxlwMPdNX6COql88v2v8FRWjvmXI0X1_Pg6dgMQ\",,,[]]";
}

- (NSString *)htmlForParserWithOneSong
{
    return [NSString stringWithFormat:@"<script type='text/javascript'>window.parent['slat_process']([[%@]]);</script>", [self jsonForParserWithOneSong]];
}

- (GoogleMusicLibraryParser *)parserWithSongDelegate:(id)delegate
{
    NSString *html = [self htmlForParserWithOneSong];
    GoogleMusicLibraryParser *parser = [[GoogleMusicLibraryParser alloc] initWithHTML:html];
    parser.songDelegate = delegate;
    return parser;
}

- (GoogleMusicLibraryParser *)parserThatDoesntNeedHTML
{
    return [[GoogleMusicLibraryParser alloc] initWithHTML:@""];
}

@end
