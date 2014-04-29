#import <Foundation/Foundation.h>
#import "Track.h"

enum GoogleMusicTrackParserField
{
    GoogleMusicTrackParserTrackId          = 0,
    GoogleMusicTrackParserTitle            = 1,
    GoogleMusicTrackParserAlbumArtUrl      = 2,
    GoogleMusicTrackParserArtist           = 3,
    GoogleMusicTrackParserAlbum            = 4,
    GoogleMusicTrackParserAlbumArtist      = 5,
    // Unknown                             = 6, null
    // Unknown                             = 7, null
    // Unknown                             = 8, null
    // Unknown                             = 9, null
    GoogleMusicTrackParserComposer         = 10,
    GoogleMusicTrackParserGenre            = 11,
    // Unknown                             = 12, null
    GoogleMusicTrackParserDuration         = 13,
    GoogleMusicTrackParserTrackNumber      = 14,
    GoogleMusicTrackParserTrackTotal       = 15,
    GoogleMusicTrackParserDiscNumber       = 16,
    GoogleMusicTrackParserDiscTotal        = 17,
    GoogleMusicTrackParserYear             = 18,
    // Unknown                             = 19, 0
    // Unknown                             = 20, null
    // Unknown                             = 21, null
    GoogleMusicTrackParserPlayCount        = 22,
    GoogleMusicTrackParserRating           = 23,
    GoogleMusicTrackParserCreationDate     = 24,
    GoogleMusicTrackParserModificationDate = 25,
    // Unknown                             = 26, null
    GoogleMusicTrackParserStoreId          = 27,
    // Unknown                             = 28, null
    GoogleMusicTrackParserType             = 29,
    GoogleMusicTrackParserComment          = 30,
    // Unknown                             = 31, null
    // Unknown                             = 32, null
    GoogleMusicTrackParserMatchedId        = 33,
    GoogleMusicTrackParserBitRate          = 34,
    GoogleMusicTrackParserLastPlayedDate   = 35,
    GoogleMusicTrackParserLargeAlbumArtUrl = 36,
    // Unknown                             = 37, null
    // Unknown                             = 38, null
    GoogleMusicTrackParserOrigin           = 39,
};

@interface GoogleMusicTrackParser : NSObject

+ (NSInteger)integerProperty:(enum GoogleMusicTrackParserField)field
                          of:(NSArray *)array
                  defaultsTo:(NSInteger)defaultValue;
+ (NSString *)stringProperty:(enum GoogleMusicTrackParserField)field
                          of:(NSArray *)array;
+ (Track *)trackFromArray:(NSArray *)array;
+ (NSInteger)integerValueOf:(NSString *)value defaultsTo:(NSInteger)defaultValue;

@end
