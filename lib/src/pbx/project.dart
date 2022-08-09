part of pbx;

mixin PBXProjectMixin on PBXElement {
  /// A reference to a [XCConfigurationList] element
  XCConfigurationList? get buildConfigurationList =>
      project.getObject(get('buildConfigurationList')) as XCConfigurationList?;

  /// A string representation of the XcodeCompatibilityVersion
  String get compatibilityVersion => get('compatibilityVersion');

  /// The region of development
  String get developmentRegion => get('developmentRegion');

  /// Whether file encodings have been scanned.
  num get hasScannedForEncodings => get('hasScannedForEncodings');

  /// The known regions for localized files.
  List<String> get knownRegions => getList('knownRegions');

  /// A reference to a [PBXGroup] element.
  PBXGroup? get mainGroup => project.getObject(get('mainGroup')) as PBXGroup?;

  /// A reference to a [PBXGroup] element.
  PBXGroup? get productRefGroup =>
      project.getObject(get('productRefGroup')) as PBXGroup?;

  /// The relative path of the project.
  String get projectDirPath => get('projectDirPath');

  List<Map> get projectReferences => getList('projectReferences');

  /// The relative root path of the project
  String get projectRoot => get('projectRoot');

  /// A list of references to [PBXTarget] elements
  List<PBXTarget> get targets => getObjectList('targets');
}

/// Element for a build target that produces a binary content (application or
/// library).
class PBXProject = PBXElement with PBXProjectMixin;
