import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/models.module.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/main.dart';
import 'package:yatadabaron/pages/_widgets/reciter_selector.dart';

class VersePlayWidget extends StatefulWidget {
  final int verseId;
  final int chapterId;

  const VersePlayWidget({
    Key? key,
    required this.verseId,
    required this.chapterId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VersePlayWidgetState();
}

class _VersePlayWidgetState extends State<VersePlayWidget> {
  final AudioPlayer player = AudioPlayer();
  StreamSubscription<AudioPlayerState>? streamSubscription;
  AudioPlayerState state = AudioPlayerState.initial;
  String? reciterKey;
  final appSettingsService = Simply.get<IAppSettingsService>();
  final audioDownloaderService = Simply.get<IAudioVerseService>();
  final tarteelService = Simply.get<ITarteelService>();
  final mushafTypeService = Simply.get<IMushafTypeService>();

  MushafType get currentMushafType => mushafTypeService.getMushafType();

  @override
  void initState() {
    super.initState();
    setState(() {
      reciterKey = tarteelService.getCachedReciterKey(currentMushafType) ??
          tarteelService.getReciterKeys(currentMushafType).first;
    });
    streamSubscription = player.playerStateStream.map((originalEvent) {
      if (originalEvent.processingState == ProcessingState.loading ||
          originalEvent.processingState == ProcessingState.buffering) {
        return AudioPlayerState.loading;
      }
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
    return Row(
      children: [
        IconButton(
          onPressed: state == AudioPlayerState.loading
              ? null
              : () async {
                  await player.stop();
                },
          icon: Icon(Icons.stop),
        ),
        IconButton(
          onPressed: state == AudioPlayerState.loading
              ? null
              : () async {
                  switch (state) {
                    case AudioPlayerState.loading:
                      return;
                    case AudioPlayerState.completed:
                    case AudioPlayerState.initial:
                      setState(() {
                        state = AudioPlayerState.loading;
                      });
                      try {
                        if (reciterKey != null) {
                          var audioUrls =
                              await audioDownloaderService.getAudioUrlsOrPath(
                            widget.chapterId,
                            widget.verseId,
                            widget.verseId,
                            reciterKey!,
                          );
                          var audioUrl = audioUrls[0];
                          await player.setAudioSource(audioUrl.isRemoteUrl()
                              ? AudioSource.uri(Uri.parse(audioUrl))
                              : AudioSource.file(audioUrl));
                          await player.play();
                        }
                      } catch (e) {
                        Utils.showInternetConnectionErrorDialog(context);
                        return;
                      }
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
        ),
        Expanded(
          flex: 1,
          child: ReciterSelector(
            onChanged: state == AudioPlayerState.initial ||
                    state == AudioPlayerState.completed
                ? (v) async {
                    if (v != null) {
                      await tarteelService.setCachedReciterKey(
                          v, currentMushafType);
                      setState(() {
                        reciterKey = v;
                      });
                    }
                  }
                : null,
            initialValue: reciterKey,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await streamSubscription?.cancel();
    await player.dispose();
  }
}

enum AudioPlayerState { paused, initial, playing, completed, loading }
