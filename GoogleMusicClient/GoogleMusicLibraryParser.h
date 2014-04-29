#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "GoogleMusicLibraryParserSongDelegate.h"
#import "GoogleMusicLibraryParserDelegate.h"

@interface GoogleMusicLibraryParser : NSObject <GoogleMusicLibraryParserSongDelegate>

@property NSString *html;

- (id)initWithHTML:(NSString *)html;
- (void)execute;
- (void)setDelegate:(id<GoogleMusicLibraryParserDelegate>)delegate;
- (void)setSongDelegate:(id<GoogleMusicLibraryParserSongDelegate>)delegate;
- (id<GoogleMusicLibraryParserSongDelegate>)songDelegate;
- (id<GoogleMusicLibraryParserDelegate>)delegate;

@end
