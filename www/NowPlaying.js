/**
 * All keys from https://developer.apple.com/library/prerelease/ios/documentation/MediaPlayer/Reference/MPNowPlayingInfoCenter_Class/index.html kan be specified
 * // Only the keys passed in will be updated, and only if they are not null
 * {
 *		albumTitle: "The Album Title",
 *		trackCount: 10,
 *		trackNumber: 1,
 *		artist: "The Artist",
 *		composer: "The Composer",
 *		discCount: 1,
 *		discNumber: 1,
 *		genre: "The Genre",
 *		persistentID: 12345,
 *		playbackDuration: 500,
 *		title: "The Title",
 *		elapsedPlaybackTime: 30,
 *		playbackRate: 1,
 *		playbackQueueIndex: 1,
 *		playbackQueueCount: 5,
 *		chapterNumber: 1,
 *		chapterCount: 2,
 *		artwork: "http://www.domain.com/image.png" / "https://www.domain.com/image.png" / "/file.png (relative to NSDocumentDirectory)"
 * }
 *
 */

var NowPlaying = {
	set: function setNowPlaying(dict, success, fail) {
		cordova.exec(success, fail, 'NowPlaying', 'setNowPlaying', [JSON.stringify(dict)]);
	}
  registerRemoteEvents: function(actionCallback) {
    this.actionCallback = actionCallback;
  },
  remotePlayerPlay: function() {
    this.actionCallback && this.actionCallback('play');
  },
  remotePlayerPause: function() {
    this.actionCallback && this.actionCallback('pause');
  }
};

module.exports = NowPlaying;
