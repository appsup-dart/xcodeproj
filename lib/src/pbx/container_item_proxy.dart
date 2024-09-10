part of '../pbx.dart';

mixin PBXContainerItemProxyMixin on PBXElement {
  /// A reference to a [PBXProject] element
  String get containerPortal => get('containerPortal');

  ///
  num get proxyType => get('proxyType');

  ///
  String get remoteGlobalIDString => get('remoteGlobalIDString');

  String get remoteInfo => get('remoteInfo');
}

/// Element for to decorate a target item
class PBXContainerItemProxy = PBXElement with PBXContainerItemProxyMixin;
