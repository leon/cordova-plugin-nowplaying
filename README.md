# Info
Allows setting the lock screen information such as artist, title, and artwork.

https://developer.apple.com/library/prerelease/ios/documentation/MediaPlayer/Reference/MPNowPlayingInfoCenter_Class/index.html

# Install

```bash
cordova plugin add cordova-plugin-nowplaying
```

# Use

> Use only the keys that you have available and leave the others out of the javascript object, that way only the correct keys will be sent to the MPNowPlayingInfoCenter.nowPlayingInfo
> It will only overwrite the values that come in by cloning the old dictionary.

```javascript
NowPlaying.set({
	artwork: "http://www.domain.com/image.png", // Can be http:// https:// or image path relative to NSDocumentDirectory
	albumTitle: "The Album Title",
	trackCount: 10,
	trackNumber: 1,
	artist: "The Artist",
	composer: "The Composer",
	discCount: 1,
	discNumber: 1,
	genre: "The Genre",
	persistentID: 12345,
	playbackDuration: 500,
	title: "The Title",
	elapsedPlaybackTime: 30,
	playbackRate: 1,
	playbackQueueIndex: 1,
	playbackQueueCount: 5,
	chapterNumber: 1,
	chapterCount: 2
});
```

You can call `NowPlaying.set` multiple times to update the keys you send in the object

```javascript
NowPlaying.set({
	artwork: "http://www.domain.com/image.png"
});

setTimeout(function () {
	NowPlaying.set({
		chapterNumber: 2
	});
}, 1000);
```

> When using in a browser environment it will simply log the calls to `NowPlaying.set` to the console.

## Hook up play / pause buttons

Use `NowPlaying.registerRemoteEvents()` to hook up the play / pause button on idle-screen to your media-player:

```javascript
NowPlaying.registerRemoteEvents( function(action) {
  switch(action) {
    case 'play':
      // Call play on your media-instanse
      mymedia.play();
      break;
    case 'pause':
      // Call pause on your media-instanse
      mymedia.pause();
      break;
  }
});
```