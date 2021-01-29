part of pbx;

mixin PBXFileElementMixin on PBXElement {
  /// The filename
  String get name => get('name');

  /// See the PBXSourceTree enumeration.
  String get sourceTree => get('sourceTree');

  PBXFileElement? get parent {
    return project.objects
        .whereType<PBXGroup>()
        .firstWhereOrNull((element) => element.children.any((v) => v == this));
  }

  String get realPath {
    var sourceTree = sourceTreeRealPath;
    var path = this.path ?? '';
    if (sourceTree != null) {
      return path_lib.join(sourceTree, path);
    }
    return path_lib.dirname(path);
  }

  String? get sourceTreeRealPath {
    switch (sourceTree) {
      case '<group>':
        var parent = this.parent;
        if (parent == null) {
          return project.projectDir + project.rootObject!.projectDirPath;
        }
        return parent.realPath;
      case 'SOURCE_ROOT':
        return project.projectDir;
      case '<absolute>':
        return null;
      default:
        return '\${$sourceTree}';
    }
  }

  /// The path to the filename
  String get path => get('path');
}

abstract class PBXFileElement = PBXElement with PBXFileElementMixin;

mixin PBXFileReferenceMixin on PBXFileElement {
  /// See the PBXFileEncoding enumeration
  num get fileEncoding => get('fileEncoding');

  /// See the PBXFileType enumeration.
  num get explicitFileType => get('explicitFileType');

  /// See the PBXFileType enumeration.
  num get lastKnownFileType => get('lastKnownFileType');
}

/// A [PBXFileReference] is used to track every external file referenced by the
/// project: source files, resource files, libraries, generated application
/// files, and so on
class PBXFileReference = PBXFileElement with PBXFileReferenceMixin;

mixin PBXGroupMixin on PBXFileElement {
  /// A list of references to [PBXFileElement] elements
  List<PBXFileElement> get children => getObjectList('children');

  PBXFileReference? addReference(String path, {String sourceTree = '<group>'}) {
    var uuid = UuidGenerator().random();

    project.set('objects/$uuid',
        {'isa': 'PBXFileReference', 'path': path, 'sourceTree': sourceTree});
    project.set('$_path/children', [...getList('children'), uuid]);

    return project.getObject(uuid) as PBXFileReference?;
  }
}

/// Element to group files or groups
class PBXGroup = PBXFileElement with PBXGroupMixin;

mixin PBXVariantGroupMixin on PBXGroup {}

/// Element for referencing localized resources
class PBXVariantGroup = PBXGroup with PBXVariantGroupMixin;
