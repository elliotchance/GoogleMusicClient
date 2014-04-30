#import <CollectionFactory/CollectionFactory.h>
#import "GoogleMusicClient.h"

/**
 * This is a hack because self is destroyed for some reason when [webView:didFinishLoadForFrame:] is called.
 */
static id<GoogleMusicLibraryParserSongDelegate> songDelegate;
static id<GoogleMusicLibraryParserDelegate> parserDelegate;
NSMutableArray *GoogleMusicLibraryParser_tracks;

@implementation GoogleMusicLibraryParser

- (id)initWithHTML:(NSString *)html
{
    self = [super init];
    if(self) {
        self.html = html;
        self.songDelegate = self;
        self.delegate = nil;
    }
    return self;
}

- (void)execute
{
    GoogleMusicLibraryParser_tracks = [NSMutableArray new];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        WebView *webView = [[WebView alloc] init];
        [webView setFrameLoadDelegate:self];
        NSURL *baseUrl = [[NSURL alloc] initWithString:@"http://localhost"];
        NSString *modifiedHtml = [NSString stringWithFormat:@"%@%@",
                                  [GoogleMusicLibraryParser javascriptHandler], self.html];
        [[webView mainFrame] loadHTMLString:modifiedHtml baseURL:baseUrl];
    });
}

+ (NSString *)javascriptHandler
{
    NSString *slat_progress = @"window.parent['slat_progress'] = function(percent) {};";
    NSString *slat_process = @"captureTracks = []; window.parent['slat_process'] = function(data) { data.forEach(function(bunchOfTracks) { if(bunchOfTracks) bunchOfTracks.forEach(function(track) { captureTracks.push(track); }) }) };";
    NSString *next_song = @"captureTracksIndex = 0; function nextTrack() { return JSON.stringify(captureTracks[captureTracksIndex++]); }";
    return [NSString stringWithFormat:@"<script>%@ %@ %@</script>", slat_progress, slat_process, next_song];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    if(sender.isLoading) {
        return;
    }
    
    NSInteger totalTracks = [[sender stringByEvaluatingJavaScriptFromString:@"captureTracks.length"] integerValue];
    for(NSUInteger i = 0; i < totalTracks; ++i) {
        NSString *nextTrack = [sender stringByEvaluatingJavaScriptFromString:@"nextTrack()"];
        [songDelegate didReceiveTrackJson:nextTrack];
    }
    
    if(nil != parserDelegate) {
        [NSThread detachNewThreadSelector:@selector(didFinishReceivingTracks:)
                                 toTarget:parserDelegate
                               withObject:GoogleMusicLibraryParser_tracks];
    }
}

- (void)setDelegate:(id<GoogleMusicLibraryParserDelegate>)delegate
{
    parserDelegate = delegate;
}

- (void)setSongDelegate:(id<GoogleMusicLibraryParserSongDelegate>)delegate
{
    songDelegate = delegate;
}

- (void)didReceiveTrackJson:(NSString *)songJson
{
    NSArray *rawTrack = [NSArray arrayWithJsonString:songJson];
    Track *track = [GoogleMusicTrackParser trackFromArray:rawTrack];
    [GoogleMusicLibraryParser_tracks addObject:track];
}

- (id<GoogleMusicLibraryParserSongDelegate>)songDelegate
{
    return songDelegate;
}

- (id<GoogleMusicLibraryParserDelegate>)delegate
{
    return parserDelegate;
}

@end
