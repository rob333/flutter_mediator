import '../rx.dart';

class RxSet<E> extends RxImpl<Set<E>> implements Set<E> {
  RxSet(Set<E> initial) : super(initial);

  @override
  Iterator<E> get iterator => value.iterator;

  @override
  bool get isEmpty => value.isEmpty;

  @override
  bool get isNotEmpty => value.isNotEmpty;

  @override
  bool add(E newValue) {
    final val = value.add(newValue);
    if (val) publishRxAspects();
    return val;
  }

  @override
  void addAll(Iterable<E> item) {
    value.addAll(item);
    publishRxAspects();
  }

  @override
  int get length => value.length;

  @override
  bool remove(Object? item) {
    final hasRemoved = value.remove(item);
    if (hasRemoved) publishRxAspects();
    return hasRemoved;
  }

  @override
  void removeWhere(bool Function(E) test) {
    value.removeWhere(test);
    publishRxAspects();
  }

  @override
  void clear() {
    value.clear();
    publishRxAspects();
  }

  @override
  E get first => value.first;

  @override
  E get last => value.last;

  @override
  bool any(bool Function(E) test) {
    return value.any(test);
  }

  @override
  Set<R> cast<R>() {
    return value.cast<R>();
  }

  @override
  bool contains(Object? element) {
    return value.contains(element);
  }

  @override
  E elementAt(int index) {
    return value.elementAt(index);
  }

  @override
  bool every(bool Function(E) test) {
    return value.every(test);
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E) f) {
    return value.expand(f);
  }

  @override
  E firstWhere(bool Function(E) test, {E Function()? orElse}) {
    return value.firstWhere(test, orElse: orElse);
  }

  @override
  T fold<T>(T initialValue, T Function(T, E) combine) {
    return value.fold(initialValue, combine);
  }

  @override
  Iterable<E> followedBy(Iterable<E> other) {
    return value.followedBy(other);
  }

  @override
  void forEach(void Function(E) f) {
    value.forEach(f);
  }

  @override
  String join([String separator = '']) {
    return value.join(separator);
  }

  @override
  E lastWhere(bool Function(E) test, {E Function()? orElse}) {
    return value.lastWhere(test, orElse: orElse);
  }

  @override
  Iterable<T> map<T>(T Function(E) f) {
    return value.map(f);
  }

  @override
  E reduce(E Function(E, E) combine) {
    return value.reduce(combine);
  }

  @override
  E get single => value.single;

  @override
  E singleWhere(bool Function(E) test, {E Function()? orElse}) {
    return value.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<E> skip(int count) {
    return value.skip(count);
  }

  @override
  Iterable<E> skipWhile(bool Function(E) test) {
    return value.skipWhile(test);
  }

  @override
  Iterable<E> take(int count) {
    return value.take(count);
  }

  @override
  Iterable<E> takeWhile(bool Function(E) test) {
    return value.takeWhile(test);
  }

  @override
  List<E> toList({bool growable = true}) {
    return value.toList(growable: growable);
  }

  @override
  Set<E> toSet() {
    return value.toSet();
  }

  @override
  Iterable<E> where(bool Function(E) test) {
    return value.where(test);
  }

  @override
  Iterable<W> whereType<W>() {
    return value.whereType<W>();
  }

  @override
  bool containsAll(Iterable<Object?> other) {
    return value.containsAll(other);
  }

  @override
  Set<E> difference(Set<Object?> other) {
    return value.difference(other);
  }

  @override
  Set<E> intersection(Set<Object?> other) {
    return value.intersection(other);
  }

  @override
  E lookup(Object? object) {
    return value.lookup(object)!;
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    value.removeAll(elements);
    publishRxAspects();
  }

  @override
  void retainAll(Iterable<Object?> elements) {
    value.retainAll(elements);
    publishRxAspects();
  }

  @override
  void retainWhere(bool Function(E) E) {
    value.retainWhere(E);
    publishRxAspects();
  }

  @override
  Set<E> union(Set<E> other) {
    return value.union(other);
  }
}

/// `rx` extension of RxSet
extension RxSetExt<E> on Set<E> {
  RxSet<E> get rx => RxSet<E>(this);
}

/// type alias
typedef SignalSet<T> = RxSet<T>;

/// `signal` extension of RxSet
extension SignalSetExt<E> on Set<E> {
  SignalSet<E> get signal => SignalSet<E>(this);
}
