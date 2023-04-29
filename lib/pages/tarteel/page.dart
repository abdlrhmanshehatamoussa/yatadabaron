import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yatadabaron/pages/tarteel/playable_item.dart';

class TarteelPage extends StatefulWidget {
  final List<TarteelPlayableItem> playableItems;

  TarteelPage({required this.playableItems});

  @override
  _TarteelPageState createState() => _TarteelPageState();
}

class _TarteelPageState extends State<TarteelPage> {
  var _audioPlayer = AudioPlayer();
  var _playlistIndex = 0;
  var _playbackState = PlaybackState.initial;
  String? chapterName;
  StreamSubscription<PlaybackState>? streamSubscription;
  StreamSubscription<int?>? indexStreamSubscription;

  @override
  void initState() {
    super.initState();

    streamSubscription = _audioPlayer.playerStateStream.map((originalEvent) {
      if (originalEvent.processingState == ProcessingState.loading ||
          originalEvent.processingState == ProcessingState.buffering) {
        return PlaybackState.loading;
      }
      if (originalEvent.processingState == ProcessingState.completed) {
        return PlaybackState.completed;
      }
      if (originalEvent.playing) {
        return PlaybackState.playing;
      }
      if (originalEvent.processingState == ProcessingState.idle) {
        return PlaybackState.initial;
      }
      return PlaybackState.paused;
    }).listen((mappedEvent) {
      setState(() {
        _playbackState = mappedEvent;
      });
    });
    indexStreamSubscription = _audioPlayer.currentIndexStream.listen((event) {
      setState(() {
        _playlistIndex = event ?? 0;
        chapterName = widget.playableItems[_playlistIndex].chapterName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chapterName ?? 'ترتيل'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.playableItems.length,
              itemBuilder: (context, index) {
                var item = widget.playableItems[index];
                return ListTile(
                  title: Text(
                    item.verseText,
                    style: TextStyle(fontFamily: "Usmani", fontSize: 25),
                  ),
                  selected: _playlistIndex == item.order,
                  selectedColor: Theme.of(context).colorScheme.secondary,
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: () async {
                    if (_audioPlayer.audioSource == null) {
                      return;
                    }
                    await _audioPlayer.seekToNext();
                    await _audioPlayer.play();
                  },
                ),
                IconButton(
                  icon: (_playbackState == PlaybackState.playing)
                      ? Icon(Icons.pause)
                      : Icon(Icons.play_arrow),
                  onPressed: _playbackState == PlaybackState.loading
                      ? null
                      : () async {
                          switch (_playbackState) {
                            case PlaybackState.loading:
                              return;
                            case PlaybackState.initial:
                            case PlaybackState.completed:
                              //Implement caching
                              await _audioPlayer.setAudioSource(
                                ConcatenatingAudioSource(
                                  children: widget.playableItems
                                      .map((item) => AudioSource.uri(
                                          Uri.parse(item.audioUrl)))
                                      .toList(),
                                ),
                              );
                              await _audioPlayer.play();
                              break;
                            case PlaybackState.playing:
                              await _audioPlayer.pause();
                              break;
                            case PlaybackState.paused:
                              await _audioPlayer.play();
                              break;
                          }
                        },
                ),
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: () async {
                    if (_audioPlayer.audioSource == null) {
                      return;
                    }
                    await _audioPlayer.seekToPrevious();
                    await _audioPlayer.play();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    streamSubscription?.cancel().then((value) {
      indexStreamSubscription?.cancel().then((value) => _audioPlayer.dispose());
    });
    super.dispose();
  }
}

enum PlaybackState { paused, initial, playing, completed, loading }
