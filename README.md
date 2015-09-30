# Install

```bash
cordova plugin add cordova-plugin-nowplaying
```

Requires linking of `MediaPlayer.framework` from XCode project settings under `General` -> `Linked Framework and Libraries`

Then from javascript you will be able to call:

> Use only the keys that you have available and leave the others out of the javascript object, that way only the correct keys will be sent to the MPNowPlayingInfoCenter.nowPlayingInfo

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
