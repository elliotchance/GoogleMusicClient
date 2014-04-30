#import <CollectionFactory/CollectionFactory.h>
#import "Downloader.h"

@implementation Downloader

- (NSData *)fetchURL:(NSURL *)URL
{
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLResponse *response;
    return [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
}

- (NSDictionary *)fetchDictionaryFromJSONURL:(NSURL *)URL
{
    NSData *jsonData = [self fetchURL:URL];
    return [NSDictionary dictionaryWithJsonData:jsonData];
}

@end
