import 'dart:io';

import 'package:snapshot/snapshot.dart';
import 'package:xcodeproj/src/plist/plain_format.dart';
import 'package:path/path.dart' as path_lib;
import 'package:xcodeproj/src/scheme.dart';
import 'pbx.dart';

mixin XCodeProjMixin on SnapshotView {
  int get archiveVersion => get('archiveVersion');

  Map<String, dynamic> get classes => getMap('classes')!;

  int get objectVersion => get('objectVersion');

  Iterable<PBXElement> get objects => snapshot
      .child('objects')
      .asMap()!
      .keys
      .map((k) => PBXElement(this as XCodeProj, 'objects/$k'));

  PBXElement? getObject(String? uuid) => uuid == null
      ? null
      : snapshot.child('objects/$uuid').value == null
          ? null
          : PBXElement(this as XCodeProj, 'objects/$uuid');

  PBXProject? get rootObject => getObject(get('rootObject')) as PBXProject?;

  /// The build configuration list of the project
  Iterable<XCConfigurationList> get buildConfigurationList =>
      objects.whereType();

  /// A list of project wide build configurations
  Iterable<XCBuildConfiguration> get buildConfigurations => objects.whereType();

  /// A list of all the files in the project
  Iterable<PBXFileReference> get files => objects.whereType();

  /// A list of all the groups in the project.
  Iterable<PBXGroup> get groups => objects.whereType();

  /// A list of all the targets in the project
  Iterable<PBXTarget> get targets => objects.whereType();
}

class XCodeProj extends ModifiableSnapshotView with XCodeProjMixin {
  final String path;

  /// the directory of the project
  String get projectDir => '${path_lib.dirname(path)}/';

  XCodeProj(this.path)
      : super.fromJson(
          plainPList.decode(File('$path/project.pbxproj').readAsStringSync()),
        );

  void save() {
    File('$path/project.pbxproj')
        .writeAsStringSync(plainPList.encode(snapshot.value));
  }

  void duplicateBuildConfiguration(String from, String to) {
    var lists = [
      rootObject!.buildConfigurationList,
      ...rootObject!.targets.map((t) => t.buildConfigurationList)
    ];

    for (var l in lists) {
      var config = l!.getByName(from);
      var toConfig = l.getByName(to);
      if (toConfig == null) {
        l.addBuildConfiguration(to,
            buildSettings: config?.buildSettings,
            baseConfigurationReference: config?.baseConfigurationReference);
      } else {
        toConfig.buildSettings = config?.buildSettings ?? {};
        toConfig.baseConfigurationReference =
            config?.baseConfigurationReference;
      }
    }
  }

  /// Get list of shared schemes in project.
  List<XCScheme> get schemes {
    var dir = Directory(path_lib.join(path, 'xcshareddata/xcschemes'));

    if (!dir.existsSync()) {
      return [];
    }

    return dir
        .listSync()
        .where((f) => f.path.endsWith('.xcscheme'))
        .map((f) => XCScheme.load(f.path)) as List<XCScheme>;
  }

  XCScheme createScheme(String name, PBXTarget target) {
    return XCScheme(path, name)..setLaunchTarget(target);
  }
}
