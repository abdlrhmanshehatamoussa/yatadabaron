import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class StreamObject<T> {
  StreamObject({T? initialValue}) {
    if (initialValue != null) {
      add(initialValue);
    }
  }
  final BehaviorSubject<T> _controller = BehaviorSubject<T>();
  Stream<T> get stream => _controller.stream;
  T get value => _controller.value;
  Function(T) get add => _controller.sink.add;
  dispose() {
    _controller.close();
  }
}

extension networkTimeoutExtensions<T> on Future<T> {
  Future<T> defaultNetworkTimeout({int? seconds}) {
    return this.timeout(
      Duration(
        seconds: seconds ?? 5,
      ),
    );
  }
}

extension NavigationExtensions on NavigatorState {
  pushWidget({required Widget view}) {
    return this.push(MaterialPageRoute(
      builder: (context) => view,
    ));
  }

  pushReplacementWidget({required Widget view}) {
    return this.pushReplacement(MaterialPageRoute(
      builder: (context) => view,
    ));
  }
}

extension StringExtensions on String {
  isRemoteUrl() {
    return startsWith("https://") || startsWith("http://");
  }
}

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
  "Saood_ash-Shuraym_64kbps": "سعود الشريم",
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
