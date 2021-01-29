part of pbx;

abstract class PBXElement extends ChildSnapshotView {
  // ignore: unused_element
  PBXElement._(XCodeProj rootSnapshotView, String path)
      : super(rootSnapshotView, path);

  factory PBXElement(XCodeProj rootSnapshotView, String path) {
    var snapshot = rootSnapshotView.snapshot.child(path);
    var isa = snapshot.child('isa').value;
    switch (isa) {
      case 'PBXAggregateTarget':
        return PBXAggregateTarget._(rootSnapshotView, path);
      case 'PBXBuildFile':
        return PBXBuildFile._(rootSnapshotView, path);
      case 'PBXContainerItemProxy':
        return PBXContainerItemProxy._(rootSnapshotView, path);
      case 'PBXCopyFilesBuildPhase':
        return PBXCopyFilesBuildPhase._(rootSnapshotView, path);
      case 'PBXFileReference':
        return PBXFileReference._(rootSnapshotView, path);
      case 'PBXFrameworksBuildPhase':
        return PBXFrameworksBuildPhase._(rootSnapshotView, path);
      case 'PBXGroup':
        return PBXGroup._(rootSnapshotView, path);
      case 'PBXHeadersBuildPhase':
        return PBXHeadersBuildPhase._(rootSnapshotView, path);
      case 'PBXLegacyTarget':
        return PBXLegacyTarget._(rootSnapshotView, path);
      case 'PBXNativeTarget':
        return PBXNativeTarget._(rootSnapshotView, path);
      case 'PBXProject':
        return PBXProject._(rootSnapshotView, path);
      case 'PBXResourcesBuildPhase':
        return PBXResourcesBuildPhase._(rootSnapshotView, path);
      case 'PBXShellScriptBuildPhase':
        return PBXShellScriptBuildPhase._(rootSnapshotView, path);
      case 'PBXSourcesBuildPhase':
        return PBXSourcesBuildPhase._(rootSnapshotView, path);
      case 'PBXTargetDependency':
        return PBXTargetDependency._(rootSnapshotView, path);
      case 'PBXVariantGroup':
        return PBXVariantGroup._(rootSnapshotView, path);
      case 'XCBuildConfiguration':
        return XCBuildConfiguration._(rootSnapshotView, path);
      case 'XCConfigurationList':
        return XCConfigurationList._(rootSnapshotView, path);
    }
    throw UnsupportedError('$isa not supported');
  }

  /// The object universally unique identifier.
  String get uuid => path.split('/').last;

  /// The project that owns the object.
  XCodeProj get project => _rootSnapshotView as XCodeProj;
}

extension PBXElementX on PBXElement {
  List<T> getObjectList<T extends PBXElement>(String path) =>
      getList(path).map((v) => project.getObject(v)).whereType<T>().toList();
}
