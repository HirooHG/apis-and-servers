extension NullList<T> on List<T> {

  T? nullWhere(bool Function(T) fun) {
    try {
      return singleWhere(fun);
    } catch (e) {
      return null;
    }
  }
}
