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

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        var chapterIndex = widget.chapterId.toString().padLeft(3, "0");
        var verseIndex = widget.verseId.toString().padLeft(3, "0");
        var reciterName = "Husary_128kbps";
        await player.setAudioSource(
          AudioSource.uri(
            Uri.parse(
              "https://everyayah.com/data/$reciterName/$chapterIndex$verseIndex.mp3",
            ),
          ),
        );
        await player.play();
      },
      icon: Icon(Icons.play_arrow),
    );
  }

  @override
  void dispose() async {
    await player.dispose();
    super.dispose();
  }
}
