part of pbx;

mixin PBXBuildFileMixin on PBXElement {
  /// A reference to a [PBXFileReference] element
  PBXFileElement? get fileRef =>
      project.getObject(get('fileRef')) as PBXFileElement?;

  /// A map of key/value pairs for additionnal settings.
  Map<String, String> get settings => getMap('settings');
}

/// Element indicate a file reference that is used in a [PBXBuildPhase] (either
/// as an include or resource)
class PBXBuildFile = PBXElement with PBXBuildFileMixin;
