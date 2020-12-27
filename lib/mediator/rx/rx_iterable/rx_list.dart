import 'dart:math';

import '../rx.dart';

class RxList<E> extends RxImpl<List<E>> implements List<E> {
  RxList(List<E> initial) : super(initial);

  @override
  Iterator<E> get iterator => value.iterator;

  @override
  bool get isEmpty => value.isEmpty;

  @override
  bool get isNotEmpty => value.isNotEmpty;

  @override
  void operator []=(int index, E val) {
    value[index] = val;
    publishRxAspects();
  }

  @override
  RxList<E> operator +(Iterable<E> val) {
    addAll(val);
    return this;
  }

  @override
  E operator [](int index) {
    return value[index];
  }

  @override
  void add(E item) {
    value.add(item);
    publishRxAspects();
  }

  @override
  void addAll(Iterable<E> item) {
    value.addAll(item);
    publishRxAspects();
  }

  @override
  void insert(int index, E item) {
    value.insert(index, item);
    publishRxAspects();
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    value.insertAll(index, iterable);
    publishRxAspects();
  }

  @override
  int get length => value.length;

  @override
  bool remove(Object? item) {
    final hasRemoved = value.remove(item);
    if (hasRemoved) {
      publishRxAspects();
    }
    return hasRemoved;
  }

  @override
  E removeAt(int index) {
    final item = value.removeAt(index);
    publishRxAspects();
    return item;
  }

  @override
  E removeLast() {
    final item = value.removeLast();
    publishRxAspects();
    return item;
  }

  @override
  void removeRange(int start, int end) {
    value.removeRange(start, end);
    publishRxAspects();
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
  void sort([int Function(E a, E b)? compare]) {
    value.sort(compare);
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
  Map<int, E> asMap() {
    return value.asMap();
  }

  @override
  List<R> cast<R>() {
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
  void fillRange(int start, int end, [E? fillValue]) {
    value.fillRange(start, end, fillValue);
    publishRxAspects();
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
  Iterable<E> getRange(int start, int end) {
    return value.getRange(start, end);
  }

  @override
  int indexOf(E element, [int start = 0]) {
    return value.indexOf(element, start);
  }

  @override
  int indexWhere(bool Function(E) test, [int start = 0]) {
    return value.indexWhere(test, start);
  }

  @override
  String join([String separator = '']) {
    return value.join(separator);
  }

  @override
  int lastIndexOf(E element, [int? start]) {
    return value.lastIndexOf(element, start);
  }

  @override
  int lastIndexWhere(bool Function(E) test, [int? start]) {
    return value.lastIndexWhere(test, start);
  }

  @override
  E lastWhere(bool Function(E) test, {E Function()? orElse}) {
    return value.lastWhere(test, orElse: orElse);
  }

  @override
  set length(int newLength) {
    value.length = newLength;
    publishRxAspects();
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
  void replaceRange(int start, int end, Iterable<E> replacement) {
    value.replaceRange(start, end, replacement);
    publishRxAspects();
  }

  @override
  void retainWhere(bool Function(E) test) {
    value.retainWhere(test);
    publishRxAspects();
  }

  @override
  Iterable<E> get reversed => value.reversed;

  @override
  void setAll(int index, Iterable<E> iterable) {
    value.setAll(index, iterable);
    publishRxAspects();
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    value.setRange(start, end, iterable, skipCount);
    publishRxAspects();
  }

  @override
  void shuffle([Random? random]) {
    value.shuffle(random);
    publishRxAspects();
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
  List<E> sublist(int start, [int? end]) {
    return value.sublist(start, end);
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
  Iterable<E> whereType<E>() {
    return value.whereType<E>();
  }

  @override
  set first(E value) {
    this[0] = value;
    // value.first = value;
    publishRxAspects();
  }

  @override
  set last(E value) {
    this[length - 1] = value;
    // value.last = value;
    publishRxAspects();
  }
}

extension RxListExtension<E> on List<E> {
  RxList<E> get rx => RxList<E>(this);
}
