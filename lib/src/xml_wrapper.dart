import 'dart:collection';

import 'package:xml/xml.dart';

class XmlElementWrapper {
  final XmlElement _element;

  XmlElementWrapper(this._element);
}

extension XmlElementWrapperX on XmlElementWrapper {
  XmlElement get element => _element;

  T get<T>(String key) {
    var v = _element.getAttribute(key);
    if (v == null) return null;

    if (T == bool) {
      return const {'YES': true, 'NO': false}[v] as T;
    }
    if (T == String) {
      return v as T;
    }
    throw ArgumentError('Cannot convert to type $T');
  }

  void set<T>(String key, T value) {
    if (value == null) {
      _element.removeAttribute(key);
    } else if (value is bool) {
      var v = const {true: 'YES', false: 'NO'}[value];
      _element.setAttribute(key, v);
    } else if (value is String) {
      _element.setAttribute(key, value);
    } else {
      throw ArgumentError('Cannot convert from type $T');
    }
  }

  Set<T> getChildren<T extends XmlElementWrapper>(
          String tagName, T Function(XmlElement element) factory) =>
      XmlNodeListWrapper(_element, tagName, factory);

  void setSingleChild(XmlElementWrapper value) {
    _element.children.removeWhere((element) =>
        element is XmlElement &&
        element.name.local == value._element.name.local &&
        element != value._element);
    if (value._element.parentElement != _element) {
      _element.children.add(value._element);
    }
  }

  T getSingleChild<T extends XmlElementWrapper>(
          String tagName, T Function(XmlElement element) factory) =>
      getChildren<T>(tagName, factory)
          .singleWhere((element) => true, orElse: () => null);
}

class XmlNodeListWrapper<T extends XmlElementWrapper> extends SetBase<T> {
  final XmlElement _element;

  final String _tagName;

  final T Function(XmlElement element) _factory;

  XmlNodeListWrapper(this._element, this._tagName, this._factory);

  @override
  bool add(T value) {
    if (contains(value)) return false;
    _element.children.add(value._element);
    return true;
  }

  @override
  bool contains(Object element) {
    return element is T && element._element.parentElement == _element;
  }

  @override
  Iterator<T> get iterator =>
      _element.findElements(_tagName).map(_factory).iterator;

  @override
  int get length => _element.findElements(_tagName).length;

  @override
  T lookup(Object element) {
    if (!contains(element)) return null;
    return element;
  }

  @override
  bool remove(Object value) {
    if (!contains(value)) return false;
    _element.children.remove((value as T)._element);
    return true;
  }

  @override
  Set<T> toSet() => {...this};
}
