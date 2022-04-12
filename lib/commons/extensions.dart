extension networkTimeoutExtensions<T> on Future<T> {
  Future<T> defaultNetworkTimeout({int? seconds}) {
    return this.timeout(
      Duration(
        seconds: seconds ?? 5,
      ),
    );
  }
}
