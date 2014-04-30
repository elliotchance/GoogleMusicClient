#import "CollectionFactory.h"
#import "GoogleMusicClient.h"

@implementation GoogleMusicClient

- (id)init
{
    self = [super init];
    if(self) {
        [self resetLoginStatus];
    }
    return self;
}

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
              delegate:(id<GoogleMusicClientDelegate>)delegate
{
    [self resetLoginStatus];
    self.loginDelegate = delegate;
    NSString *post = [NSString stringWithFormat:@"&Email=%@&Passwd=%@&service=sj", email, password];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.com/accounts/ClientLogin"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (BOOL)isLoggedIn
{
    return self.loggedIn;
}

- (void)resetLoginStatus
{
    self.loggedIn = NO;
    self.loginAborted = NO;
    self.stage = GoogleMusicClientStageWaitingOnAuthToken;
    self.theProfileSettings = nil;
}

- (void)abortLogin
{
    [self resetLoginStatus];
    self.loginAborted = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d
{
    switch(self.stage) {
        
        case GoogleMusicClientStageWaitingOnAuthToken:
        {
            NSString *response = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
            NSArray *respArray = [response componentsSeparatedByString:@"\n"];
            if([respArray count] < 3) {
                [self abortLogin];
                break;
            }
            response = [respArray objectAtIndex:2];
            self.authToken = [response stringByReplacingOccurrencesOfString:@"Auth=" withString:@""];
            break;
        }
        
        case GoogleMusicClientStagePerformAuth:
        {
            // Nab the almighty xt cookie's data, it's important.
            NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for(NSHTTPCookie *cookie in [cookieJar cookies]) {
                if([[cookie name] isEqualToString:@"xt"]) {
                    self.xtToken = [cookie value];
                }
            }
            
            if(self.loggedIn == NO) {
                self.loggedIn = YES;
                [self.loginDelegate loginDidSucceed];
            }
            break;
        }
        
    }
}

- (void)performAuth
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://play.google.com/music/listen?u=0"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"GoogleLogin auth=%@", self.authToken] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(self.loginAborted) {
        [self.loginDelegate loginDidFail];
        return;
    }
    
    if(self.stage == GoogleMusicClientStageWaitingOnAuthToken) {
        self.stage = GoogleMusicClientStagePerformAuth;
        [self performAuth];
    }
}

- (NSMutableURLRequest *)requestForService:(NSString *)service
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"https://play.google.com/music/services/%@?u=0&xt=%@&format=jsarray", service, self.xtToken];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    NSString *googleAuth = [NSString stringWithFormat:@"GoogleLogin auth=%@", self.authToken];
    [request setValue:googleAuth forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return request;
}

- (void)requestService:(NSString *)service
     completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))handler
{
    NSMutableURLRequest *request = [self requestForService:service];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:handler];
}

- (NSData *)synchronouslyRequestService:(NSString *)service
{
    NSMutableURLRequest *request = [self requestForService:service];
    NSURLResponse *response;
    return [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
}

- (void)loadProfileSettings
{
    if(nil == self.theProfileSettings) {
        GoogleMusicClient *this = self;
        NSData *data = [self synchronouslyRequestService:@"loadsettings"];
        this.theProfileSettings = [NSMutableDictionary mutableDictionaryWithJsonData:data];
    }
}

- (NSDictionary *)profileSettings
{
    [self loadProfileSettings];
    return self.theProfileSettings;
}

+ (NSUInteger)maximumWaitTimeForRequest
{
    return 10;
}

- (id)labProfileSetting:(NSString *)name
{
    NSArray *labs = [[self profileSettings] valueForKeyPath:@"settings.labs"];
    for(NSDictionary *setting in labs) {
        if([[setting objectForKey:@"title"] isEqualToString:name]) {
            return setting;
        }
    }
    @throw [NSException exceptionWithName:@"NoSuchProfileSetting" reason:@"" userInfo:nil];
}

- (BOOL)desktopNotications
{
    id setting = [self labProfileSetting:@"Desktop Notifications"];
    return [[setting objectForKey:@"enabled"] boolValue];
}

- (BOOL)useHTML5Audio
{
    id setting = [self labProfileSetting:@"HTML5 Audio"];
    return [[setting objectForKey:@"enabled"] boolValue];
}

- (BOOL)use5StarRatings
{
    id setting = [self labProfileSetting:@"5-Star Ratings"];
    return [[setting objectForKey:@"enabled"] boolValue];
}

- (BOOL)viewTrackComments
{
    id setting = [self labProfileSetting:@"View Track Comments"];
    return [[setting objectForKey:@"enabled"] boolValue];
}

- (BOOL)chromecastFireplaceVisualizer
{
    id setting = [self labProfileSetting:@"Chromecast Fireplace Visualizer"];
    return [[setting objectForKey:@"enabled"] boolValue];
}

- (id)profileSettingForKeyPath:(NSString *)keyPath
{
    id setting = [[self profileSettings] valueForKeyPath:keyPath];
    if(nil == setting) {
        @throw [NSException exceptionWithName:@"NoSuchProfileSetting" reason:@"" userInfo:nil];
    }
    return setting;
}

- (BOOL)accountIsCanceled
{
    return [[self profileSettingForKeyPath:@"settings.isCanceled"] boolValue];
}

- (BOOL)accountIsSubscription
{
    return [[self profileSettingForKeyPath:@"settings.isSubscription"] boolValue];
}

- (BOOL)accountIsTrial
{
    return [[self profileSettingForKeyPath:@"settings.isTrial"] boolValue];
}

- (BOOL)accountIsSubscribedToNewsletter
{
    return [[self profileSettingForKeyPath:@"settings.subscriptionNewsletter"] boolValue];
}

- (NSInteger)accountMaximumAllowedTracks
{
    return [[self profileSettingForKeyPath:@"settings.maxTracks"] integerValue];
}

- (NSDate *)accountExpireTime
{
    NSInteger seconds = [[self profileSettingForKeyPath:@"settings.expirationMillis"] integerValue] / 1000;
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:seconds];
    return d;
}

- (GoogleMusicLibraryParser *)libraryParserWithHTML:(NSString *)html
{
    return [[GoogleMusicLibraryParser alloc] initWithHTML:html];
}

- (void)fetchAllTracksWithDelegate:(id<GoogleMusicLibraryParserDelegate>)delegate
{
    __block GoogleMusicClient *this = self;
    [self requestService:@"streamingloadalltracks"
       completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        GoogleMusicLibraryParser *parser = [this libraryParserWithHTML:html];
        parser.delegate = delegate;
        [parser execute];
    }];
}

@end
