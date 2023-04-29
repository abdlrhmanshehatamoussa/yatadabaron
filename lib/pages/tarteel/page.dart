import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:yatadabaron/pages/tarteel/playable_item.dart';

class TarteelPage extends StatefulWidget {
  final List<TarteelPlayableItem> playableItems;
  final String reciterName;

  TarteelPage({
    required this.playableItems,
    required this.reciterName,
  });

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
  final ItemScrollController scrollController = ItemScrollController();

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
        scrollController.jumpTo(
          index: _playlistIndex,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = 35;
    var iconColor = Theme.of(context).colorScheme.onBackground;
    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(
          child: Text(
            "${widget.reciterName} ($chapterName)",
            style: TextStyle(fontSize: 25),
          ),
          scrollDirection: Axis.horizontal,
        ),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.skip_next,
                    size: iconSize,
                    color: iconColor,
                  ),
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
                      ? Icon(
                          Icons.pause,
                          size: iconSize,
                          color: iconColor,
                        )
                      : Icon(
                          Icons.play_arrow,
                          size: iconSize,
                          color: iconColor,
                        ),
                  onPressed: _playbackState == PlaybackState.loading
                      ? null
                      : () async {
                          switch (_playbackState) {
                            case PlaybackState.loading:
                              return;
                            case PlaybackState.initial:
                            case PlaybackState.completed:
                              //TODO: Implement caching
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
                  icon: Icon(
                    Icons.skip_previous,
                    size: iconSize,
                    color: iconColor,
                  ),
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
          Expanded(
            child: ScrollablePositionedList.separated(
              itemScrollController: scrollController,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: widget.playableItems.length,
              initialScrollIndex: _playlistIndex,
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
