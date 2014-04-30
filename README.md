GoogleMusicClient
=================

[![Build Status](https://travis-ci.org/elliotchance/GoogleMusicClient.svg?branch=master)](https://travis-ci.org/elliotchance/GoogleMusicClient)

This is an implementation of the [Unofficial Google Music API](https://github.com/simon-weber/Unofficial-Google-Music-API) written in Objective-C.

Usage
-----

Use it with [CocoaPods](http://cocoapods.org):

```
pod 'GoogleMusicClient'
```

Then include it in your source code:

```
#import <GoogleMusicClient.h>
```

Basic Client
------------

### Login

```
GoogleMusicClient *client = [GoogleMusicClient new];
[client loginWithEmail:@"a@b.com" password:@"foobar" delegate:self];
```

The `delegate` is an asynchronous `id<GoogleMusicClientDelegate>` which will return one of the following callbacks:

 * `- loginDidSucceed`
 * `- loginDidFail`
 * `- doesNotHaveInternet`

The protocol that wraps the client provides `- (BOOL)isLoggedIn` so you can check the connection status at any time.
 
### Profile Settings

The client provides the following settings, these are synchronous but are cached until the next time you connect:

 * `- (NSDictionary *)profileSettings` - get all profile settings as a dictionary.
 * `- (BOOL)desktopNotications` - has the client enabled desktop notifcations.
 * `- (BOOL)useHTML5Audio` - does the client wish to use HTML5 audio instead of Adobe Flash.
 * `- (BOOL)use5StarRatings` - does the client want to use the "5 star rating" system over the thumbs up/down.
 * `- (BOOL)viewTrackComments` - does the client which to show track comments.
 * `- (BOOL)chromecastFireplaceVisualizer` - does the client with use the visualiser on chromecast.

### Account Settings

Various status flags are available - most of them are pretty self-explanitory:

 * `- (BOOL)accountIsCanceled`
 * `- (BOOL)accountIsSubscription`
 * `- (BOOL)accountIsTrial`
 * `- (BOOL)accountIsSubscribedToNewsletter`
 * `- (NSInteger)accountMaximumAllowedTracks` - this should be 20,000 for normal paid accounts.
 * `- (NSDate *)accountExpireTime`

Media Library
-------------

### Fetch All Tracks

You may fetch the entire library asynchronously with:

`- (void)fetchAllTracksWithDelegate:(id<GoogleMusicLibraryParserDelegate>)delegate`

`delegate` will callback with:

`- (void)didFinishReceivingTracks:(NSArray *)tracks`

`tracks` will contain an array of `Track` objects.

### Track

The following meta data is available:

 * `- (NSString *)album`
 * `- (NSString *)albumArtUrl`
 * `- (NSString *)albumArtist`
 * `- (NSString *)artist`
 * `- (NSUInteger)bitRate`
 * `- (NSString *)composer`
 * `- (NSString *)comment`
 * `- (NSDate *)creationDate`
 * `- (NSUInteger)discNumber`
 * `- (NSUInteger)discTotal`
 * `- (NSTimeInterval)duration`
 * `- (NSString *)genre`
 * `- (NSString *)largeAlbumArtUrl`
 * `- (NSDate *)lastPlayedDate`
 * `- (NSString *)matchedId`
 * `- (NSDate *)modificationDate`
 * `- (NSArray *)origin`
 * `- (NSUInteger)playCount`
 * `- (NSUInteger)rating`
 * `- (NSString *)storeId`
 * `- (NSString *)trackId`
 * `- (NSString *)title`
 * `- (NSUInteger)trackNumber`
 * `- (NSUInteger)trackTotal`
 * `- (enum TrackType)type`
 * `- (NSUInteger)year`
 
### Getting the Track Stream URL

`- (NSURL *)streamUrl` is provided on the `Track` class that will make a synchronous call (the stream URL is not provided with the track, it must be fetched afterwards) to get the stream URL. This URL can be used with any media player that understands streaming MP3.