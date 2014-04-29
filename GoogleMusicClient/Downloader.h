#import <Foundation/Foundation.h>

@interface Downloader : NSObject

- (NSData *)fetchURL:(NSURL *)URL;
- (NSDictionary *)fetchDictionaryFromJSONURL:(NSURL *)URL;

@end
