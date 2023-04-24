import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SingleVersePlayButton extends StatefulWidget {
  final int verseId;
  final int chapterId;

  const SingleVersePlayButton({
    Key? key,
    required this.verseId,
    required this.chapterId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SingleVersePlayButtonState();
}

class _SingleVersePlayButtonState extends State<SingleVersePlayButton> {
  final AudioPlayer player = AudioPlayer();
  StreamSubscription<PlayerState>? streamSubscription;
  PlayerState state = PlayerState.stopped;

  @override
  void initState() {
    super.initState();
    streamSubscription = player.onPlayerStateChanged.listen((playerState) {
      setState(() {
        state = playerState;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        switch (state) {
          case PlayerState.completed:
          case PlayerState.stopped:
            var chapterIndex = widget.chapterId.toString().padLeft(3, "0");
            var verseIndex = widget.verseId.toString().padLeft(3, "0");
            var reciterName = "Husary_128kbps";
            await player.play(
              UrlSource(
                "https://everyayah.com/data/$reciterName/$chapterIndex$verseIndex.mp3",
              ),
            );
            break;
          case PlayerState.playing:
            await player.pause();
            break;
          case PlayerState.paused:
            await player.resume();
            break;
        }
      },
      icon: (state == PlayerState.playing)
          ? Icon(Icons.pause)
          : Icon(Icons.play_arrow),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await streamSubscription?.cancel();
    await player.dispose();
  }
}
