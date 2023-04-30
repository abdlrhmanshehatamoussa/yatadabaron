import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/main.dart';

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
  final appSettingsService = Simply.get<IAppSettingsService>();
  final audioDownloaderService = Simply.get<IVerseAudioDownloader>();

  @override
  void initState() {
    super.initState();
    if (appSettingsService.currentValue.reciterKey != null) {
      setState(() {
        reciterKey = appSettingsService.currentValue.reciterKey!;
      });
    }
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
                        var audioUrl =
                            await audioDownloaderService.getAudioUrlOrPath(
                          widget.verseId,
                          widget.chapterId,
                          reciterKey,
                        );
                        await player.setAudioSource(audioUrl.isRemoteUrl()
                            ? AudioSource.uri(Uri.parse(audioUrl))
                            : AudioSource.file(audioUrl));
                        await player.play();
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
                ? (v) async {
                    if (v != null) {
                      await appSettingsService.updateReciter(v);
                      setState(() {
                        reciterKey = v;
                      });
                    }
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

enum AudioPlayerState { paused, initial, playing, completed, loading }

final reciterNameMap = {
  "Husary_128kbps": "الحصري",
  "Husary_128kbps_Mujawwad": "الحصري - مجود",
  "Husary_Muallim_128kbps": "الحصري - معلم",
  "Abdul_Basit_Mujawwad_128kbps": "عبد الباسط مجود",
  "Abdul_Basit_Murattal_192kbps": "عبد الباسط مرتل",
  "Minshawy_Murattal_128kbps": "المنشاوي - مرتل",
  "Minshawy_Mujawwad_192kbps": "المنشاوي - مجود",
  "mahmoud_ali_al_banna_32kbps": "محمود علي البنا",
  "Mohammad_al_Tablaway_128kbps": "محمد الطبلاوي",
  "Saood_ash-Shuraym_128kbps": "سعود الشريم",
  "MaherAlMuaiqly128kbps": "ماهر المعيقلي",
  "Alafasy_128kbps": "مشاري العفاسي",
  "Abdurrahmaan_As-Sudais_192kbps": "عبد الرحمن السديس",
  "Muhammad_Ayyoub_128kbps": "محمد أيوب",
  "Muhammad_Jibreel_128kbps": "محمد جبريل",
  "Ahmed_Neana_128kbps": "أحمد نعينع",
  "Ali_Jaber_64kbps": "علي جابر",
  "Yasser_Ad-Dussary_128kbps": "ياسر الدوسري",
  "Abdullaah_3awwaad_Al-Juhaynee_128kbps": "عبد الله عواد الجهني",
  "ahmed_ibn_ali_al_ajamy_128kbps": "أحمد ابن علي العجمي",
  "Ghamadi_40kbps": "الغامدي",
  "Hudhaify_128kbps": "الحذيفي",
  "Fares_Abbad_64kbps": "فارس عباد",
  "Ayman_Sowaid_64kbps": "أيمن سويد",
  "Abu_Bakr_Ash-Shaatree_128kbps": "أبو بكر الشاطري",
  "Abdullah_Basfar_192kbps": "عبد الله بصفر",
  "Abdullah_Matroud_128kbps": "عبد الله مطرود",
  "Akram_AlAlaqimy_128kbps": "أكرم العلاقمي",
  "Ali_Hajjaj_AlSuesy_128kbps": "علي حجاج السويسي",
  "aziz_alili_128kbps": "عزيز العلي",
  "Hani_Rifai_192kbps": "هاني الرفاعي",
  "Khaalid_Abdullaah_al-Qahtaanee_192kbps": "خالد عبد الله القحطاني",
  "khalefa_al_tunaiji_64kbps": "خليفة الطنيجي",
  "Muhammad_AbdulKareem_128kbps": "محمد عبد الكريم",
  "Muhsin_Al_Qasim_192kbps": "محسن القاسم",
  "Nasser_Alqatami_128kbps": "ناصر القطامي",
  "Sahl_Yassin_128kbps": "سهل ياسين",
  "Salaah_AbdulRahman_Bukhatir_128kbps": "صلاح بو خاطر",
  "Salah_Al_Budair_128kbps": "صلاح البدير",
  "Yaser_Salamah_128kbps": "ياسر سلامة",
};
