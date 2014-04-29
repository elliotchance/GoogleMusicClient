#import <Foundation/Foundation.h>

@protocol GoogleMusicLibraryParserDelegate <NSObject>

- (void)didFinishReceivingTracks:(NSArray *)tracks;

@end
