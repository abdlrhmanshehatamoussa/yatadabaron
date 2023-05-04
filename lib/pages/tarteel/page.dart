import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wakelock/wakelock.dart';
import 'package:yatadabaron/global.dart';
import 'package:yatadabaron/main.dart';
import 'package:yatadabaron/pages/_viewmodels/module.dart';
import 'package:yatadabaron/pages/tafseer/view.dart';
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
    Wakelock.enable();
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
        centerTitle: true,
        title: SingleChildScrollView(
          child: Text(
            "${widget.reciterName}",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          scrollDirection: Axis.horizontal,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight * 1.5),
          child: Wrap(
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
                                  await _audioPlayer.setAudioSource(
                                    ConcatenatingAudioSource(
                                      children: widget.playableItems
                                          .map((item) => item.audioUrl
                                                  .isRemoteUrl()
                                              ? AudioSource.uri(
                                                  Uri.parse(item.audioUrl))
                                              : AudioSource.file(item.audioUrl))
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
              chapterName != null
                  ? Container(
                      alignment: Alignment.center,
                      child: Text(
                        chapterName!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 20,
                          fontFamily: "Usmani",
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
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
                    "${item.verseText} ${item.verseId.toArabicNumber()}",
                    style: TextStyle(fontFamily: "Usmani", fontSize: 25),
                  ),
                  selected: _playlistIndex == item.order,
                  selectedColor: Theme.of(context).colorScheme.secondary,
                  onTap: () async {
                    await _audioPlayer.pause();
                    var playableItem = widget.playableItems
                        .firstWhere((i) => i.order == _playlistIndex);
                    appNavigator.pushWidget(
                      view: TafseerPage(
                        location: MushafLocation(
                          chapterId: playableItem.chapterId,
                          verseId: playableItem.verseId,
                        ),
                      ),
                    );
                  },
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
    Wakelock.disable();
    super.dispose();
  }
}

enum PlaybackState { paused, initial, playing, completed, loading }
