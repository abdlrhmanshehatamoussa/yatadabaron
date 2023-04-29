import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

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
  String reciterKey = "Husary_128kbps";
  final reciterNameMap = {
    "AbdulSamad_64kbps_QuranExplorer.Com": "Abdul Basit Abdul Samad",
    "Abdul_Basit_Mujawwad_128kbps": "Abdul Basit Mujawwad",
    "Abdul_Basit_Murattal_192kbps": "Abdul Basit Murattal",
    "Abdullaah_3awwaad_Al-Juhaynee_128kbps": "Abdullaah Awaad Al-Juhaynee",
    "Abdullah_Basfar_192kbps": "Abdullah Basfar",
    "Abdullah_Matroud_128kbps": "Abdullah Matroud",
    "Abdurrahmaan_As-Sudais_192kbps": "Abdurrahmaan As-Sudais",
    "Abu_Bakr_Ash-Shaatree_128kbps": "Abu Bakr Ash-Shaatree",
    "Ahmed_Neana_128kbps": "Ahmed Neana",
    "Ahmed_ibn_Ali_al-Ajamy_128kbps_ketaballah.net": "Ahmed Ibn Ali Al-Ajamy",
    "Akram_AlAlaqimy_128kbps": "Akram AlAlaqimy",
    "Alafasy_128kbps": "Alafasy",
    "Ali_Hajjaj_AlSuesy_128kbps": "Ali Hajjaj AlSuesy",
    "Ali_Jaber_64kbps": "Ali Jaber",
    "Ayman_Sowaid_64kbps": "Ayman Sowaid",
    "Fares_Abbad_64kbps": "Fares Abbad",
    "Ghamadi_40kbps": "Ghamadi",
    "Hani_Rifai_192kbps": "Hani Rifai",
    "Hudhaify_128kbps": "Hudhaify",
    "Husary_128kbps": "Al Husary",
    "Husary_128kbps_Mujawwad": "Al Husary - Mujawwad",
    "Husary_Muallim_128kbps": "Al Husary - Muallim",
    "Khaalid_Abdullaah_al-Qahtaanee_192kbps": "Khaalid Abdullaah Al-Qahtaanee",
    "MaherAlMuaiqly128kbps": "Maher AlMuaiqly",
    "Minshawy_Mujawwad_192kbps": "Al Minshawy - Mujawwad",
    "Minshawy_Murattal_128kbps": "Al Minshawy - Murattal",
    "Mohammad_al_Tablaway_128kbps": "Mohammad Al Tablaway",
    "Muhammad_AbdulKareem_128kbps": "Muhammad AbdulKareem",
    "Muhammad_Ayyoub_128kbps": "Muhammad Ayyoub",
    "Muhammad_Jibreel_128kbps": "Muhammad Jibreel",
    "Muhsin_Al_Qasim_192kbps": "Muhsin Al Qasim",
    "Nasser_Alqatami_128kbps": "Nasser Alqatami ",
    "Sahl_Yassin_128kbps": "Sahl Yassin ",
    "Salaah_AbdulRahman_Bukhatir_128kbps": "Salaah AbdulRahman Bukhatir",
    "Salah_Al_Budair_128kbps": "Salah Al Budair",
    "Saood_ash-Shuraym_128kbps": "Saood Ash-Shuraym",
    "Yaser_Salamah_128kbps": "Yaser Salamah",
    "Yasser_Ad-Dussary_128kbps": "Yasser Ad-Dussary",
    "ahmed_ibn_ali_al_ajamy_128kbps": "Ahmed Ibn Ali Al-Ajamy",
    "aziz_alili_128kbps": "Aziz Alili",
    "khalefa_al_tunaiji_64kbps": "Khalefa Al Tunaiji",
    "mahmoud_ali_al_banna_32kbps": "Mahmoud Ali Al Banna",
  };

  @override
  void initState() {
    super.initState();
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
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            await player.stop();
          },
          icon: Icon(Icons.stop),
        ),
        IconButton(
          onPressed: () async {
            switch (state) {
              case AudioPlayerState.completed:
              case AudioPlayerState.initial:
                var chapterIndex = widget.chapterId.toString().padLeft(3, "0");
                var verseIndex = widget.verseId.toString().padLeft(3, "0");
                var url =
                    "https://everyayah.com/data/$reciterKey/$chapterIndex$verseIndex.mp3";
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
        ),
        Expanded(
          flex: 1,
          child: DropdownButton<String>(
            isExpanded: true,
            items: reciterNameMap.keys
                .map((reciterKey) => DropdownMenuItem<String>(
                      child: SingleChildScrollView(
                        child: Text(reciterNameMap[reciterKey] ?? ""),
                        padding: EdgeInsets.all(10),
                        scrollDirection: Axis.horizontal,
                      ),
                      value: reciterKey,
                    ))
                .toList(),
            onChanged: state == AudioPlayerState.initial ||
                    state == AudioPlayerState.completed
                ? (v) {
                    setState(() {
                      if (v != null) {
                        reciterKey = v;
                      }
                    });
                  }
                : null,
            value: reciterKey,
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

enum AudioPlayerState { paused, initial, playing, completed }
