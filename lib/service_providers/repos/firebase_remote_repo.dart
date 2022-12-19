import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yatadabaron/services/_i_remote_repository.dart';
import '../mappers/i_mapper.dart';

class FirebaseRemoteRepository<T> implements IRemoteRepository<T> {
  final IMapper<T> mapper;
  final String collectionName;

  FirebaseRemoteRepository({
    required this.mapper,
    required this.collectionName,
  });

  @override
  Future<List<T>> fetchAll() async {
    var responseSnapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();
    var list = responseSnapshot.docs.map((e) {
      var jsonStr = jsonEncode(e.data());
      return mapper.fromJsonStr(jsonStr);
    }).toList();
    return list;
  }
}
