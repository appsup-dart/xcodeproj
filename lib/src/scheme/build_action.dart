part of xcodeproj.xcscheme;

class BuildAction extends XmlElementWrapper {
  BuildAction._(XmlElement element) : super(element);

  factory BuildAction(
      {bool buildImplicitDependencies = true,
      bool parallelizeBuildables = true}) {
    return BuildAction._(XmlElement(XmlName('BuildAction')))
      ..buildImplicitDependencies = buildImplicitDependencies
      ..parallelizeBuildables = parallelizeBuildables;
  }

  /// Whether or not to detect and build implicit dependencies for each target
  bool get buildImplicitDependencies => get('buildImplicitDependencies');

  set buildImplicitDependencies(bool value) =>
      set('buildImplicitDependencies', value);

  /// Whether or not to build the various targets in parallel
  bool get parallelizeBuildables => get('parallelizeBuildables');

  set parallelizeBuildables(bool value) => set('parallelizeBuildables', value);

  /// The set of [BuildActionEntry]s associated with this Build Action.
  ///
  /// Each entry represent a target to build and tells for which action it's
  /// needed to be built.
  Set<BuildActionEntry> get entries =>
      getChildren('BuildActionEntries', (e) => BuildActionEntry._(e));
}

class BuildActionEntry extends XmlElementWrapper {
  BuildActionEntry._(XmlElement element) : super(element);

  factory BuildActionEntry(
      {bool buildForAnalyzing = false,
      bool buildForArchiving = false,
      bool buildForProfiling = false,
      bool buildForRunning = false,
      bool buildForTesting = false}) {
    return BuildActionEntry._(XmlElement(XmlName('BuildActionEntries')))
      ..buildForAnalyzing = buildForAnalyzing
      ..buildForArchiving = buildForArchiving
      ..buildForProfiling = buildForProfiling
      ..buildForRunning = buildForRunning
      ..buildForTesting = buildForTesting;
  }

  /// Whether or not to build this target when building for Testing
  bool get buildForTesting => get('buildForTesting');

  set buildForTesting(bool value) => set('buildForTesting', value);

  /// Whether or not to build this target when building for Running
  bool get buildForRunning => get('buildForRunning');

  set buildForRunning(bool value) => set('buildForRunning', value);

  /// Whether or not to build this target when building for Profiling
  bool get buildForProfiling => get('buildForProfiling');

  set buildForProfiling(bool value) => set('buildForProfiling', value);

  /// Whether or not to build this target when building for Archiving
  bool get buildForArchiving => get('buildForArchiving');

  set buildForArchiving(bool value) => set('buildForArchiving', value);

  /// Whether or not to build this target when building for Analyzing
  bool get buildForAnalyzing => get('buildForAnalyzing');

  set buildForAnalyzing(bool value) => set('buildForAnalyzing', value);

  /// The list of [BuildableReference]s this entry will build.
  Set<BuildableReference> get buildableReferences => getChildren(
      'BuildableReference', (element) => BuildableReference._(element));
}

class BuildableReference extends XmlElementWrapper {
  BuildableReference._(XmlElement element) : super(element);

  factory BuildableReference({PBXTarget target}) {
    return BuildableReference._(
        XmlElement(XmlName('BuildableReference'))
          ..setAttribute('BuildableIdentifier', 'primary'))
      ..setReferenceTarget(target, overrideBuildableName: true);
  }

  /// The name of the final product when building this Buildable Reference.
  String get buildableName => get('BuildableName');

  set buildableName(String value) => set('BuildableName', value);

  /// The name of the target this Buildable Reference points to
  String get targetName => get('BlueprintName');

  /// The Unique Identifier of the target (target.uuid) this Buildable Reference points to.
  String get targetUuid => get('BlueprintIdentifier');

  /// The string representing the container of that target.
  String get targetReferencedContainer => get('ReferencedContainer');

  void setReferenceTarget(PBXTarget target,
      {bool overrideBuildableName = false, XCodeProj rootProject}) {
    set('BlueprintIdentifier', target.uuid);

    if (overrideBuildableName) buildableName = _constructBuildableName(target);
    set('BlueprintName', target.name);
    set('ReferencedContainer',
        _constructReferencedContainerUri(target, rootProject));
  }

  String _constructBuildableName(PBXTarget target) {
    if (target is PBXNativeTarget) {
      return path_lib.basename(target.productReference.path);
    } else if (target is PBXAggregateTarget) {
      return target.name;
    }
    throw ArgumentError('Unsupported build target type ${target.runtimeType}');
  }

  String _constructReferencedContainerUri(PBXTarget target,
      [XCodeProj rootProject]) {
    var targetProject = target.project;

    rootProject ??= targetProject;
    var rootProjectDirPath = rootProject.rootObject.projectDirPath;

    var path = (rootProjectDirPath != null && rootProjectDirPath.isNotEmpty)
        ? (rootProject.path + rootProjectDirPath)
        : rootProject.projectDir;
    var relativePath = path_lib.relative(targetProject.path, from: path);
    if (relativePath == '.') {
      relativePath = path_lib.basename(targetProject.path);
    }
    return 'container:${relativePath}';
  }
}
