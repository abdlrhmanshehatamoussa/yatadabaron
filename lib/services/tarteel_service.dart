import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/models/enums.dart';
import '../service_contracts/i_tarteel_service.dart';

class TarteelService implements ITarteelService {
  final SharedPreferences sharedPreferences;

  TarteelService({required this.sharedPreferences});

  @override
  List<String> getReciterKeys(MushafType mushafType) {
    return _map[mushafType]!.keys.toList();
  }

  @override
  String getReciterName(String reciterKey) {
    if (reciterKey.isEmpty) return "";
    List<MapEntry<String, String>> allValues =
        _map.entries.map((e) => e.value).expand((i) => i.entries).toList();
    if (allValues.any((v) => v.key == reciterKey)) {
      return allValues.firstWhere((v) => v.key == reciterKey).value;
    }
    return "";
  }

  @override
  String? getCachedReciterKey(MushafType mushafType) {
    return sharedPreferences.getString(_getReciterSharedPrefKey(mushafType)) ??
        null;
  }

  @override
  Future<void> setCachedReciterKey(
    String reciterKey,
    MushafType mushafType,
  ) async {
    await sharedPreferences.setString(
        _getReciterSharedPrefKey(mushafType), reciterKey);
  }

  @override
  List<int>? getTarteelLocationCache(MushafType mushafType) {
    try {
      var key = _getTarteelLocationSharedPrefKey(mushafType);
      var listStr = this.sharedPreferences.getStringList(key);
      if (listStr == null || listStr.isEmpty) {
        return null;
      }
      return listStr.map((e) => int.parse(e)).toList();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setTarteelLocationCache(
    List<int> location,
    MushafType mushafType,
  ) async {
    var key = _getTarteelLocationSharedPrefKey(mushafType);
    var locationString = location.map((e) => e.toString()).toList();
    await sharedPreferences.setStringList(key, locationString);
  }

  String _getReciterSharedPrefKey(MushafType mushafType) {
    return "reciter_key_${mushafType.toString()}";
  }

  String _getTarteelLocationSharedPrefKey(MushafType mushafType) {
    return "tarteel_location_key_${mushafType.toString()}";
  }

  final _map = {
    MushafType.HAFS: {
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
    },
    MushafType.WARSH: {
      "warsh/warsh_Abdul_Basit_128kbps": "عبد الباسط - ورش",
    },
  };
}
