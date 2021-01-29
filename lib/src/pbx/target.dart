part of pbx;

mixin PBXTargetMixin on PBXElement {
  /// A reference to a [XCConfigurationList] element
  XCConfigurationList? get buildConfigurationList =>
      project.getObject(get('buildConfigurationList')) as XCConfigurationList?;

  /// A list of references to [PBXBuildPhase] elements
  List<PBXBuildPhase> get buildPhases => getObjectList('buildPhases');

  /// A list of references to [PBXTargetDependency] elements
  List<PBXTargetDependency> get dependencies => getObjectList('dependencies');

  /// The name of the target
  String get name => get('name');

  /// The product name
  String get productName => get('productName');
}

abstract class PBXTarget = PBXElement with PBXTargetMixin;

mixin PBXAggregateTargetMixin on PBXTarget {}

/// Element for a build target that aggregates several others
class PBXAggregateTarget = PBXTarget with PBXAggregateTargetMixin;

mixin PBXLegacyTargetMixin on PBXTarget {}

class PBXLegacyTarget = PBXTarget with PBXLegacyTargetMixin;

mixin PBXNativeTargetMixin on PBXTarget {
  /// The product install path.
  String get productInstallPath => get('productInstallPath');

  /// A reference to a [PBXFileReference] element
  PBXFileReference? get productReference =>
      project.getObject(get('productReference')) as PBXFileReference?;

  /// See the PBXProductType enumeration
  String get productType => get('productType');
}

/// Element for a build target that produces a binary content (application or
/// library).
class PBXNativeTarget = PBXTarget with PBXNativeTargetMixin;

mixin PBXTargetDependencyMixin on ChildSnapshotView implements PBXElement {
  /// A reference to a [PBXNativeTarget] element.
  String get target => get('target');

  /// A reference to a [PBXContainerItemProxy] element.
  String get targetProxy => get('targetProxy');
}

/// Element for referencing other target through content proxies.
class PBXTargetDependency = PBXElement with PBXTargetDependencyMixin;
