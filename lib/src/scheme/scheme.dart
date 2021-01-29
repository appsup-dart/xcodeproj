part of xcodeproj.xcscheme;

class XCScheme extends XmlElementWrapper {
  String _path;

  XCScheme._(this._path, XmlElement element) : super(element);

  factory XCScheme.load(String path) {
    var doc = XmlDocument.parse(File(path).readAsStringSync());
    return XCScheme._(path, doc.findElements('Scheme').first);
  }

  factory XCScheme(String projectPath, String name, {bool shared = true}) {
    var e = XmlElement(XmlName('Scheme'))
      ..setAttribute('LastUpgradeVersion', '1100')
      ..setAttribute('version', '1.3');

    XmlDocument([
      XmlDeclaration([
        XmlAttribute(XmlName('version'), '1.0'),
        XmlAttribute(XmlName('encoding'), 'UTF-8'),
      ]),
      e
    ]);

    var dir = Directory(path_lib.join(
        projectPath,
        shared
            ? 'xcshareddata/xcschemes'
            : 'xcuserdata/${Platform.environment['USER']}.xcuserdatad/xcschemes'));

    var path = path_lib.join(dir.path, '$name.xcscheme');

    return XCScheme._(path, e)
      ..buildAction = BuildAction()
      ..testAction = TestAction()
      ..launchAction = LaunchAction()
      ..profileAction = ProfileAction()
      ..analyzeAction = AnalyzeAction()
      ..archiveAction = ArchiveAction();
  }

  AnalyzeAction get analyzeAction =>
      getSingleChild('AnalyzeAction', (e) => AnalyzeAction._(e))!;

  set analyzeAction(AnalyzeAction value) => setSingleChild(value);

  ArchiveAction get archiveAction =>
      getSingleChild('ArchiveAction', (e) => ArchiveAction._(e))!;

  set archiveAction(ArchiveAction value) => setSingleChild(value);

  BuildAction get buildAction =>
      getSingleChild('BuildAction', (e) => BuildAction._(e))!;

  set buildAction(BuildAction value) => setSingleChild(value);

  LaunchAction get launchAction =>
      getSingleChild('LaunchAction', (e) => LaunchAction._(e))!;

  set launchAction(LaunchAction value) => setSingleChild(value);

  ProfileAction get profileAction =>
      getSingleChild('ProfileAction', (e) => ProfileAction._(e))!;

  set profileAction(ProfileAction value) => setSingleChild(value);

  TestAction get testAction =>
      getSingleChild('TestAction', (e) => TestAction._(e))!;

  set testAction(TestAction value) => setSingleChild(value);

  void setLaunchTarget(PBXTarget target) {
    var launchRunnable = BuildableProductRunnable()
      ..buildableReference = (BuildableReference(target: target));

    launchAction.buildableProductRunnable = launchRunnable;

    var profileRunnable = BuildableProductRunnable()
      ..buildableReference = (BuildableReference(target: target));

    profileAction.buildableProductRunnable = profileRunnable;

    var macroExp = MacroExpansion()
      ..buildableReference = (BuildableReference(target: target));

    testAction.macroExpansions.add(macroExp);
  }

  void save() {
    var file = File(_path);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(element.document!.toXmlString(pretty: true));
  }
}

abstract class SchemeAction extends XmlElementWrapper {
  SchemeAction(XmlElement element) : super(element);

  /// The build configuration associated with this action (usually either 'Debug' or 'Release').
  String? get buildConfiguration => get('buildConfiguration');

  set buildConfiguration(String? value) => set('buildConfiguration', value);
}
