abstract class IMapper<T> {
  T fromJsonStr(String json);
  String toJsonStr(T obj);
  bool isIdentical(T obj, T obj2);
}
