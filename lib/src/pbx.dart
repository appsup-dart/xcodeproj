library pbx;

import 'dart:collection';

import 'package:snapshot/snapshot.dart';
import 'package:xcodeproj/src/uuid.dart';
import 'package:xcodeproj/src/xcode.dart';
import 'package:quiver/core.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as path_lib;

part 'pbx/build_file.dart';
part 'pbx/build_phase.dart';
part 'pbx/container_item_proxy.dart';
part 'pbx/element.dart';
part 'pbx/file_element.dart';
part 'pbx/project.dart';
part 'pbx/target.dart';
part 'pbx/build_configuration.dart';

class ChildSnapshotView {
  final SnapshotView _rootSnapshotView;

  final String _path;

  ChildSnapshotView(this._rootSnapshotView, this._path);

  Snapshot get _snapshot => _rootSnapshotView.snapshot.child(_path);

  @override
  int get hashCode => hash2(_rootSnapshotView, _path);

  @override
  bool operator ==(other) =>
      other is ChildSnapshotView &&
      other._rootSnapshotView == _rootSnapshotView &&
      other._path == _path;
}

extension ChildSnapshotViewX on ChildSnapshotView {
  Snapshot get snapshot => _snapshot;

  String get path => _path;

  /// Gets and converts the value at [path] to type T
  T get<T>(String path, {String? format}) =>
      _snapshot.child(path).as(format: format);

  /// Gets and converts the value at [path] to type List&lt;T&gt;
  List<T> getList<T>(String path, {String? format}) =>
      _snapshot.child(path).asList(format: format)!;

  /// Gets and converts the value at [path] to type Map&lt;String,T&gt;
  Map<String, T> getMap<T>(String path, {String? format}) =>
      ChildSnapshotMapView(_rootSnapshotView, '$_path/$path');
}

class ChildSnapshotMapView<T> extends ChildSnapshotView
    with MapMixin<String, T> {
  final String? format;

  ChildSnapshotMapView(SnapshotView rootSnapshotView, String path,
      {this.format})
      : super(rootSnapshotView, path);

  @override
  T? operator [](Object? key) =>
      _rootSnapshotView.getMap(_path)![key as String];

  @override
  void operator []=(String key, T value) {
    if (_rootSnapshotView is ModifiableSnapshotView) {
      (_rootSnapshotView as ModifiableSnapshotView).set('$path/$key', value);
    } else {
      throw UnsupportedError('This snapshot view is unmodifiable');
    }
  }

  @override
  void clear() {
    if (_rootSnapshotView is ModifiableSnapshotView) {
      (_rootSnapshotView as ModifiableSnapshotView).set(path, {});
    } else {
      throw UnsupportedError('This snapshot view is unmodifiable');
    }
  }

  @override
  Iterable<String> get keys => _rootSnapshotView.getMap(path)!.keys;

  @override
  T remove(Object? key) {
    if (_rootSnapshotView is ModifiableSnapshotView) {
      var v = (_rootSnapshotView as ModifiableSnapshotView).get('$_path/$key');
      (_rootSnapshotView as ModifiableSnapshotView).set('$_path/$key', null);
      return v;
    } else {
      throw UnsupportedError('This snapshot view is unmodifiable');
    }
  }
}
