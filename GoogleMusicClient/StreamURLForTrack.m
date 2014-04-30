#import <NSURL+QueryDictionary.h>
#import <MBHMAC/NSString+MBHMAC.h>
#import <CollectionFactory.h>
#import "StreamURLForTrack.h"
#import "RandomStringGenerator.h"
#import "Downloader.h"

@implementation StreamURLForTrack

+ (NSURL *)streamURLForTrackWithId:(NSString *)trackId
{
    StreamURLForTrack *service = [[StreamURLForTrack alloc] initWithTrackId:trackId];
    return [service fetchStreamURL];
}

- (id)initWithTrackId:(NSString *)trackId
{
    self = [super init];
    if(self) {
        self.trackId = trackId;
        self.downloader = [Downloader new];
    }
    return self;
}

- (NSDictionary *)parametersForStreamUrlUsingSalt:(NSString *)salt signature:(NSString *)sig
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSNumber numberWithInteger:0] forKey:@"u"];
    [params setValue:@"e" forKey:@"pt"];
    [params setValue:salt forKey:@"slt"];
    [params setValue:sig forKey:@"sig"];
    
    if([self.trackId characterAtIndex:0] == 'T') {
        [params setValue:self.trackId forKey:@"mjck"];
    }
    else {
        [params setValue:self.trackId forKey:@"songid"];
    }
    
    return [NSDictionary dictionaryWithDictionary:params];
}

- (NSURL *)baseURL
{
    return [NSURL URLWithString:@"https://play.google.com/music/play"];
}

- (NSString *)accessKey
{
    return @"27f7313e-f75d-445a-ac99-56386a5fe879";
}

- (NSString *)randomSalt
{
    enum RandomStringGeneratorOption options = RandomStringGeneratorOptionLowerCaseAlphabet | RandomStringGeneratorOptionNumbers;
    return [RandomStringGenerator randomStringOfLength:12 options:options];
}

- (NSURL *)URLForJsonMetaData
{
    NSString *salt = [self randomSalt];
    NSString *package = [NSString stringWithFormat:@"%@%@", self.trackId, salt];
    NSString *sig = [package hmacWithHashingAlgorithm:kCCHmacAlgSHA1 key:[self accessKey]];
    NSDictionary *params = [self parametersForStreamUrlUsingSalt:salt signature:sig];
    return [[self baseURL] uq_URLByAppendingQueryDictionary:params];
}

- (NSURL *)fetchStreamURL
{
    NSURL *playUrl = [self URLForJsonMetaData];
    NSDictionary *result = [self.downloader fetchDictionaryFromJSONURL:playUrl];
    return [NSURL URLWithString:[result valueForKey:@"url"]];
}

@end
