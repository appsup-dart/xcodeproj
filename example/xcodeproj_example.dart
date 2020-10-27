import 'package:xcodeproj/xcodeproj.dart';

void main(List<String> args) {
  var proj = XCodeProj(args.first);

  printAllTargets(proj);
  printAllSourceFiles(proj.targets.last);
  setBuildConfigurationToAllTargets(proj, 'MY_CUSTOM_FLAG', 'TRUE');

  printTree(proj.rootObject.mainGroup, '');

  printBuildConfigurations(proj);
}

void printBuildConfigurations(XCodeProj proj) {
  print('Root project');
  for (var config
      in proj.rootObject.buildConfigurationList.buildConfigurations) {
    print('  ${config.name}');
    print('    ${config.baseConfigurationReference?.realPath ?? ''}');
  }
  for (var target in proj.targets) {
    print(target.name);
    for (var config in target.buildConfigurationList.buildConfigurations) {
      print('  ${config.name}');
      print('    ${config.baseConfigurationReference?.realPath ?? ''}');
    }
  }
}

void printTree(PBXGroup group, String indent) {
  for (var c in group.children) {
    print('$indent - ${c.name ?? c.path ?? ""}');
    if (c is PBXGroup) {
      printTree(c, indent + ' ');
    }
  }
}

// Look through all targets
void printAllTargets(XCodeProj proj) {
  print('*** TARGETS ***');
  for (var t in proj.targets) {
    print('- ${t.name}');
  }
  print('');
}

// Get all source files for a target
void printAllSourceFiles(PBXTarget target) {
  print('*** SOURCE FILES FOR TARGET ${target.name} ***');
  for (var b in target.buildPhases) {
    print('- build phase: ${b.runtimeType}');
    for (var f in b.files) {
      print('  - ${f.fileRef.realPath}');
    }
  }
  print('');
}

// Set a specific build configuration to all targets
void setBuildConfigurationToAllTargets(
    XCodeProj proj, String key, dynamic value) {
  for (var target in proj.targets) {
    for (var config in target.buildConfigurationList.buildConfigurations) {
      config.buildSettings[key] = value;
    }
  }
  proj.save();
}
