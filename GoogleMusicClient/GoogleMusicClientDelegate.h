#import <Foundation/Foundation.h>

@protocol GoogleMusicClientDelegate <NSObject>

- (void)loginDidSucceed;
- (void)loginDidFail;
- (void)libraryDidFinishSynchronizing;
- (void)doesNotHaveInternet;

@end
