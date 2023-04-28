import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

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
  StreamSubscription<AudioPlayerState>? streamSubscription;
  AudioPlayerState state = AudioPlayerState.initial;

  @override
  void initState() {
    super.initState();
    // streamSubscription = player.onPlayerStateChanged.listen((playerState) {
    //   setState(() {
    //     state = playerState;
    //   });
    // });
    streamSubscription = player.playerStateStream.map((originalEvent) {
      if (originalEvent.processingState == ProcessingState.completed) {
        return AudioPlayerState.completed;
      }
      if (originalEvent.playing) {
        return AudioPlayerState.playing;
      }
      if (originalEvent.processingState == ProcessingState.idle) {
        return AudioPlayerState.initial;
      }
      return AudioPlayerState.paused;
    }).listen((mappedEvent) {
      setState(() {
        state = mappedEvent;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        switch (state) {
          case AudioPlayerState.completed:
          case AudioPlayerState.initial:
            var chapterIndex = widget.chapterId.toString().padLeft(3, "0");
            var verseIndex = widget.verseId.toString().padLeft(3, "0");
            var reciterName = "Husary_128kbps";
            var url =
                "https://everyayah.com/data/$reciterName/$chapterIndex$verseIndex.mp3";
            await player.setAudioSource(AudioSource.uri(Uri.parse(url)));
            await player.play();
            break;
          case AudioPlayerState.playing:
            await player.pause();
            break;
          case AudioPlayerState.paused:
            await player.play();
            break;
        }
      },
      icon: (state == AudioPlayerState.playing)
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

enum AudioPlayerState { paused, initial, playing, completed }
