abstract class IMapper<T> {
  T fromJsonStr(String json);
  String toJsonStr(T obj);
}
