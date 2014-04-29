#import <Foundation/Foundation.h>

@protocol GoogleMusicLibraryParserSongDelegate <NSObject>

- (void)didReceiveTrackJson:(NSString *)trackJson;

@end
