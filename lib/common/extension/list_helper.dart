
extension ListHelper<T> on List<T> {
  T? nullWhere(bool Function(T param) fun) {
    try {
      return singleWhere(fun);
    } catch(e) {
      return null;
    }
  }
}
