#import <Foundation/Foundation.h>

enum TrackType
{
    TrackTypeFreeOrPurchased    = 1,
    TrackTypeUploadedNotMatched = 2,
    TrackTypeUploadedMatched    = 6,
};

const static NSUInteger UnknownBitRate = 0;
const static NSUInteger UnknownYear = 0;
const static NSUInteger UnknownTrackNumber = 0;
const static NSUInteger UnknownTrackTotal = 0;
const static NSUInteger UnknownDiscNumber = 0;
const static NSUInteger UnknownDiscTotal = 0;
const static NSUInteger UnknownDuration = 0;
const static NSUInteger UnknownType = TrackTypeFreeOrPurchased;
const static NSUInteger UnknownRating = 0;

@interface Track : NSObject

// properties from Google
@property NSString *album;
@property NSString *albumArtUrl;
@property NSString *albumArtist;
@property NSString *artist;
@property NSUInteger bitRate;
@property NSString *composer;
@property NSString *comment;
@property NSDate *creationDate;
@property NSUInteger discNumber;
@property NSUInteger discTotal;
@property NSTimeInterval duration;
@property NSString *genre;
@property NSString *largeAlbumArtUrl;
@property NSDate *lastPlayedDate;
@property NSString *matchedId;
@property NSDate *modificationDate;
@property NSArray *origin;
@property NSUInteger playCount;
@property (nonatomic) NSUInteger rating;
@property NSString *storeId;
@property (nonatomic) NSString *trackId;
@property NSString *title;
@property NSUInteger trackNumber;
@property NSUInteger trackTotal;
@property enum TrackType type;
@property NSUInteger year;

// other properties
@property NSDate *lastSynchronized;

- (id)archiveValueForKey:(NSString *)key;
- (void)setArchiveValue:(id)value forKey:(NSString *)key;
+ (NSString *)attributeTitleFromName:(NSString *)name;
+ (NSDictionary *)attributes;
+ (BOOL)validateTrackId:(NSString *)trackId;
- (id)initWithTrackId:(NSString *)trackId;
- (void)setRating:(NSUInteger)rating;
- (NSURL *)streamUrl;

@end
