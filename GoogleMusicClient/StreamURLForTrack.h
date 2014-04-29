#import <Foundation/Foundation.h>
#import "Downloader.h"

@interface StreamURLForTrack : NSObject

@property NSString *trackId;
@property Downloader *downloader;

- (id)initWithTrackId:(NSString *)theTrackId;
- (NSDictionary *)parametersForStreamUrlUsingSalt:(NSString *)salt signature:(NSString *)sig;
- (NSURL *)fetchStreamURL;
- (NSURL *)baseURL;
- (NSString *)accessKey;
- (NSString *)randomSalt;
- (NSURL *)URLForJsonMetaData;

+ (NSURL *)streamURLForTrackWithId:(NSString *)trackId;

@end
