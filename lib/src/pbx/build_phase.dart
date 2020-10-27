part of pbx;

mixin PBXBuildPhaseMixin on PBXElement {
  num get buildActionMask => get('buildActionMask');

  /// A list of references to [PBXBuildFile] elements
  List<PBXBuildFile> get files => getObjectList('files');

  num get runOnlyForDeploymentPostprocessing =>
      get('runOnlyForDeploymentPostprocessing');
}

abstract class PBXBuildPhase = PBXElement with PBXBuildPhaseMixin;

mixin PBXAppleScriptBuildPhaseMixin on PBXBuildPhaseMixin {}

mixin PBXCopyFilesBuildPhaseMixin on PBXBuildPhaseMixin {
  /// The destination path
  String get dstPath => get('dstPath');

  num get dstSubfolderSpec => get('dstSubfolderSpec');
}

/// Element for the copy file build phase.
class PBXCopyFilesBuildPhase = PBXBuildPhase with PBXCopyFilesBuildPhaseMixin;

mixin PBXFrameworksBuildPhaseMixin on PBXBuildPhaseMixin {}

/// Element for the framework link build phase.
class PBXFrameworksBuildPhase = PBXBuildPhase with PBXFrameworksBuildPhaseMixin;

mixin PBXHeadersBuildPhaseMixin on PBXBuildPhaseMixin {}

/// Element for the framework link build phase.
class PBXHeadersBuildPhase = PBXBuildPhase with PBXHeadersBuildPhaseMixin;

mixin PBXResourcesBuildPhaseMixin on PBXBuildPhaseMixin {}

/// Element for the resources copy build phase.
class PBXResourcesBuildPhase = PBXBuildPhase with PBXResourcesBuildPhaseMixin;

mixin PBXShellScriptBuildPhaseMixin on PBXBuildPhaseMixin {
  /// The input paths
  List<String> get inputPaths => get('inputPaths');

  /// The output paths
  List<String> get outputPaths => get('outputPaths');

  /// The path to the shell interpreter
  String get shellPath => get('shellPath');

  /// The content of the script shell
  String get shellScript => get('shellScript');
}

/// Element for the resources copy build phase.
class PBXShellScriptBuildPhase = PBXBuildPhase
    with PBXShellScriptBuildPhaseMixin;

mixin PBXSourcesBuildPhaseMixin on PBXBuildPhaseMixin {}

/// Element for the sources compilation build phase.
class PBXSourcesBuildPhase = PBXBuildPhase with PBXSourcesBuildPhaseMixin;
