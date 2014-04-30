#import <objc/runtime.h>
#import <CollectionFactory.h>
#import "GoogleMusicClient.h"

@implementation Track

- (id)init
{
    @throw [NSException exceptionWithName:NSGenericException
                                   reason:@"[init] is protected. You must use [initWithTrackId:]"
                                 userInfo:nil];
}

- (id)initWithTrackId:(NSString *)trackId
{
    self = [super init];
    if(self) {
        self.trackId = trackId;
        self.title = @"";
        self.album = @"";
        self.albumArtUrl = @"";
        self.albumArtist = @"";
        self.artist = @"";
        self.bitRate = UnknownBitRate;
        self.genre = @"";
        self.creationDate = [NSDate date];
        self.year = UnknownYear;
        self.trackNumber = UnknownTrackNumber;
        self.trackTotal = UnknownTrackTotal;
        self.discNumber = UnknownDiscNumber;
        self.discTotal = UnknownDiscTotal;
        self.type = TrackTypeFreeOrPurchased;
        self.duration = UnknownDuration;
        self.origin = [NSArray new];
        self.lastSynchronized = [NSDate date];
        self.composer = @"";
        self.playCount = 0;
        self.rating = UnknownRating;
        self.comment = @"";
        self.largeAlbumArtUrl = @"";
        self.modificationDate = [NSDate date];
        self.lastPlayedDate = [NSDate date];
        self.storeId = @"";
        self.matchedId = @"";
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if(nil == value) {
        NSString *message = [NSString stringWithFormat:@"Trying to assign nil to %@", key];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:message
                                     userInfo:nil];
    }
    [super setValue:value forKey:key];
}

- (NSString *)description
{
    NSDictionary *dictionary = [self dictionaryValue];
    return [dictionary description];
}

+ (NSString *)attributeTitleFromName:(NSString *)name
{
    NSMutableString *result = [NSMutableString new];
    for(NSUInteger i = 0; i < [name length]; ++i) {
        unichar c = [name characterAtIndex:i];
        if(c >= 'A' && c <= 'Z') {
            [result appendString:@" "];
        }
        [result appendFormat:@"%c", c];
    }
    return [result capitalizedString];
}

+ (NSDictionary *)attributes
{
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([Track class], &outCount);
    NSMutableDictionary *array = [NSMutableDictionary new];
    for(int i = 0; i < outCount; ++i) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:propName];
        [array setObject:[Track attributeTitleFromName:key] forKey:key];
    }
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:array];
}

- (id)archiveValueForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    if([value isKindOfClass:[NSArray class]]) {
        return [value jsonValue];
    }
    return value;
}

- (void)setArchiveValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"origin"]) {
        value = [NSArray arrayWithJsonString:value];
        if(nil == value) {
            value = [NSArray new];
        }
    }
    [self setValue:value forKey:key];
}

+ (BOOL)validateTrackId:(NSString *)trackId
{
    NSString *regex = @"[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}";
    NSPredicate *validator = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [validator evaluateWithObject:trackId];
}

- (void)setTrackId:(NSString *)trackId
{
    if(![Track validateTrackId:trackId]) {
        NSString *reason = [NSString stringWithFormat:@"Invalid track ID: %@", trackId];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
    }
    self->_trackId = trackId;
}

- (void)setRating:(NSUInteger)rating
{
    if(rating > 5) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"rating must be between 0 and 5"
                                     userInfo:nil];
    }
    self->_rating = rating;
}

- (NSURL *)streamUrl
{
    return [StreamURLForTrack streamURLForTrackWithId:self.trackId];
}

@end
