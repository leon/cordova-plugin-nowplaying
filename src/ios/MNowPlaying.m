#import "MNowPlaying.h"

@implementation MNowPlaying

static MNowPlaying *remoteControls = nil;

- (void)pluginInitialize
{
    NSLog(@"NowPlaying plugin init.");
}

/**
 * Will set now playing info based on what keys are sent into method
 */
- (void)setNowPlaying:(CDVInvokedUrlCommand*)command
{
    // Parse json data
    NSString* jsonStr = [command.arguments objectAtIndex:0];
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    // If the json object could not be parsed we exit early
    if (jsonObject == nil) {
        NSLog(@"Could not parse now playing json object");
        return;
    }
    
    //
    NSMutableDictionary *mediaDict = [[NSMutableDictionary alloc] init];
    
    if ([jsonObject objectForKey: @"albumTitle"] != nil) {
        [mediaDict setValue:[jsonObject objectForKey: @"albumTitle"] forKey:MPMediaItemPropertyAlbumTitle];
    }
    
    if ([jsonObject objectForKey: @"trackCount"] != nil) {
        [mediaDict setValue:[jsonObject objectForKey: @"trackCount"] forKey:MPMediaItemPropertyAlbumTrackCount];
    }
    
    if ([jsonObject objectForKey: @"trackNumber"] != nil) {
        [mediaDict setValue:[jsonObject objectForKey: @"trackNumber"] forKey:MPMediaItemPropertyAlbumTrackNumber];
    }
    
    if ([jsonObject objectForKey: @"artist"] != nil) {
        [mediaDict setValue:[jsonObject objectForKey: @"artist"] forKey:MPMediaItemPropertyArtist];
    }
    
    if ([jsonObject objectForKey: @"composer"] != nil) {
        [mediaDict setValue:[jsonObject objectForKey: @"composer"] forKey:MPMediaItemPropertyComposer];
    }
    
    if ([jsonObject objectForKey: @"discCount"] != nil) {
        [mediaDict setValue:[jsonObject objectForKey: @"discCount"] forKey:MPMediaItemPropertyDiscCount];
    }
    
    if ([jsonObject objectForKey: @"discNumber"] != nil) {
        [mediaDict setValue:[jsonObject objectForKey: @"discNumber"] forKey:MPMediaItemPropertyDiscNumber];
    }
    
    if ([jsonObject objectForKey: @"genre"] != nil) {
        [mediaDict setValue:[jsonObject objectForKey: @"genre"] forKey:MPMediaItemPropertyGenre];
    }
    
    if ([jsonObject objectForKey: @"persistentID"] != nil) {
        [mediaDict setValue:[jsonObject objectForKey: @"persistentID"] forKey:MPMediaItemPropertyPersistentID];
    }
    
    if ([jsonObject objectForKey: @"playbackDuration"] != nil) {
        [mediaDict setValue:[jsonObject objectForKey: @"playbackDuration"] forKey:MPMediaItemPropertyPlaybackDuration];
    }
    
    if ([jsonObject objectForKey: @"title"] != nil) {
        [mediaDict setValue:[jsonObject objectForKey: @"title"] forKey:MPMediaItemPropertyTitle];
    }
    
    if ([jsonObject objectForKey: @"elapsedPlaybackTime"] != nil) {
        [mediaDict setValue:[jsonObject objectForKey: @"elapsedPlaybackTime"] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    }
    
    if ([jsonObject objectForKey: @"playbackRate"] != nil) {
        [mediaDict setValue:[jsonObject objectForKey: @"playbackRate"] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    }
    
    if ([jsonObject objectForKey: @"playbackQueueIndex"] != nil) {
        [mediaDict setValue:[jsonObject objectForKey: @"playbackQueueIndex"] forKey:MPNowPlayingInfoPropertyPlaybackQueueIndex];
    }
    
    if ([jsonObject objectForKey: @"playbackQueueCount"] != nil) {
        [mediaDict setValue:[jsonObject objectForKey: @"playbackQueueCount"] forKey:MPNowPlayingInfoPropertyPlaybackQueueCount];
    }
    
    if ([jsonObject objectForKey: @"chapterNumber"] != nil) {
        [mediaDict setValue:[jsonObject objectForKey: @"chapterNumber"] forKey:MPNowPlayingInfoPropertyChapterNumber];
    }
    
    if ([jsonObject objectForKey: @"chapterCount"] != nil) {
        [mediaDict setValue:[jsonObject objectForKey: @"chapterCount"] forKey:MPNowPlayingInfoPropertyChapterCount];
    }

    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    center.nowPlayingInfo = mediaDict;
    
    // Custom handling of artwork
    if ([jsonObject objectForKey: @"artwork"] != nil) {
        [self setNowPlayingArtwork: [jsonObject objectForKey: @"artwork"]];
    }
}

/**
 * Will download the image in a background thread and set the appropiate key on nowPlayingInfo
 */
- (void)setNowPlayingArtwork:(NSString*)url
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage *image = nil;
        // check whether cover path is present
        if (![url isEqual: @""]) {
            // cover is remote file
            if ([url hasPrefix: @"http://"] || [url hasPrefix: @"https://"]) {
                NSURL *imageURL = [NSURL URLWithString:url];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                image = [UIImage imageWithData:imageData];
            }
            // cover is local file
            else {
                NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *fullPath = [NSString stringWithFormat:@"%@%@", basePath, url];
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
                if (fileExists) {
                    image = [UIImage imageNamed:fullPath];
                }
            }
        }

        // Check if image was available otherwise don't do anything
        if (image == nil) {
            return;
        }

        // check whether image is loaded
        CGImageRef cgref = [image CGImage];
        CIImage *cim = [image CIImage];
        if (cim != nil || cgref != NULL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
                MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage: image];
                center.nowPlayingInfo = [NSDictionary dictionaryWithObjectsAndKeys: artwork, MPMediaItemPropertyArtwork, nil];
            });
        }
    });
}

@end