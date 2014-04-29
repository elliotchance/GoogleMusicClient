#import "GoogleMusicTrackParser.h"

@implementation GoogleMusicTrackParser

+ (Track *)trackFromArray:(NSArray *)array
{
    NSString *trackId = [array objectAtIndex:GoogleMusicTrackParserTrackId];
    Track *track = [[Track alloc] initWithTrackId:trackId];
    
    track.album = [self stringProperty:GoogleMusicTrackParserAlbum of:array];
    track.albumArtUrl = [self stringProperty:GoogleMusicTrackParserAlbumArtUrl of:array];
    track.albumArtist = [self stringProperty:GoogleMusicTrackParserAlbumArtist of:array];
    track.artist = [self stringProperty:GoogleMusicTrackParserArtist of:array];
    track.genre = [self stringProperty:GoogleMusicTrackParserGenre of:array];
    track.title = [self stringProperty:GoogleMusicTrackParserTitle of:array];
    track.composer = [self stringProperty:GoogleMusicTrackParserComposer of:array];
    track.comment = [self stringProperty:GoogleMusicTrackParserComment of:array];
    track.largeAlbumArtUrl = [self stringProperty:GoogleMusicTrackParserLargeAlbumArtUrl of:array];
    track.storeId = [self stringProperty:GoogleMusicTrackParserStoreId of:array];
    track.matchedId = [self stringProperty:GoogleMusicTrackParserMatchedId of:array];
    
    track.creationDate = [self dateProperty:GoogleMusicTrackParserCreationDate of:array];
    track.modificationDate = [self dateProperty:GoogleMusicTrackParserModificationDate of:array];
    track.lastPlayedDate = [self dateProperty:GoogleMusicTrackParserLastPlayedDate of:array];
    
    track.bitRate = [self integerProperty:GoogleMusicTrackParserBitRate of:array defaultsTo:UnknownBitRate];
    track.discNumber = [self integerProperty:GoogleMusicTrackParserDiscNumber of:array defaultsTo:UnknownDiscNumber];
    track.discTotal = [self integerProperty:GoogleMusicTrackParserDiscTotal of:array defaultsTo:UnknownDiscTotal];
    track.duration = [self integerProperty:GoogleMusicTrackParserDuration of:array defaultsTo:UnknownDuration];
    track.trackNumber = [self integerProperty:GoogleMusicTrackParserTrackNumber of:array defaultsTo:UnknownTrackNumber];
    track.trackTotal = [self integerProperty:GoogleMusicTrackParserTrackTotal of:array defaultsTo:UnknownTrackTotal];
    track.year = [self integerProperty:GoogleMusicTrackParserYear of:array defaultsTo:UnknownYear];
    track.playCount = [self integerProperty:GoogleMusicTrackParserPlayCount of:array defaultsTo:0];
    track.rating = [self integerProperty:GoogleMusicTrackParserRating of:array defaultsTo:UnknownRating];
    
    track.type = (enum TrackType) [self integerProperty:GoogleMusicTrackParserType of:array defaultsTo:UnknownType];
    
    track.origin = [array objectAtIndex:GoogleMusicTrackParserOrigin];
    
    return track;
}

+ (NSDate *)dateProperty:(enum GoogleMusicTrackParserField)field
                      of:(NSArray *)array
{
    unsigned long long value = [[array objectAtIndex:field] unsignedLongLongValue] / 1000000;
    return [NSDate dateWithTimeIntervalSince1970:value];
}

+ (NSString *)stringProperty:(enum GoogleMusicTrackParserField)field
                          of:(NSArray *)array
{
    if(field >= [array count]) {
        return @"";
    }
    id value = [array objectAtIndex:field];
    if(![value isKindOfClass:[NSString class]]) {
        return @"";
    }
    return value;
}

+ (NSInteger)integerProperty:(enum GoogleMusicTrackParserField)field
                          of:(NSArray *)array
                  defaultsTo:(NSInteger)defaultValue
{
    if(field >= [array count]) {
        return defaultValue;
    }
    return [GoogleMusicTrackParser integerValueOf:[array objectAtIndex:field] defaultsTo:defaultValue];
}

+ (NSInteger)integerValueOf:(NSString *)value defaultsTo:(NSInteger)defaultValue
{
    NSScanner* scan = [NSScanner scannerWithString:[value description]];
    int val;
    if([scan scanInt:&val] && [scan isAtEnd]) {
        return [value integerValue];
    }
    return defaultValue;
}

@end
