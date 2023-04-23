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
  var _playbackState = PlaybackState.none;
  StreamSubscription<PlayerState>? streamSubscription;
  StreamSubscription<int?>? indexStreamSubscription;

  @override
  void initState() {
    super.initState();
    _audioPlayer
        .setAudioSource(
      ConcatenatingAudioSource(
        children: widget.playableItems
            .map((item) => AudioSource.uri(Uri.parse(item.audioUrl)))
            .toList(),
      ),
    )
        .then((value) {
      streamSubscription = _audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.playing) {
          setState(() {
            _playbackState = PlaybackState.playing;
          });
        } else if (playerState.processingState == ProcessingState.completed) {
          setState(() {
            _playbackState = PlaybackState.stopped;
          });
        } else {
          setState(() {
            _playbackState = PlaybackState.paused;
          });
        }
      });
      indexStreamSubscription = _audioPlayer.currentIndexStream.listen((event) {
        setState(() {
          _playlistIndex = event ?? 0;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ترتيل'),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.pause),
                  onPressed: _playbackState == PlaybackState.playing
                      ? () async => await _audioPlayer.pause()
                      : null,
                ),
                SizedBox(width: 16.0),
                IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: _playbackState == PlaybackState.paused ||
                          _playbackState == PlaybackState.stopped
                      ? () async {
                          await _audioPlayer.play();
                        }
                      : null,
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

enum PlaybackState { none, playing, paused, stopped }
