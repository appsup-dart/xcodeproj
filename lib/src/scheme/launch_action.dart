part of xcodeproj.xcscheme;

class LaunchAction extends SchemeAction {
  LaunchAction._(XmlElement element) : super(element);

  factory LaunchAction(
      {String buildConfiguration = 'Debug',
      bool allowLocationSimulation = true}) {
    return LaunchAction._(XmlElement(XmlName('LaunchAction'))
      ..setAttribute('selectedDebuggerIdentifier',
          'Xcode.DebuggerFoundation.Debugger.LLDB')
      ..setAttribute('selectedLauncherIdentifier',
          'Xcode.DebuggerFoundation.Launcher.LLDB')
      ..setAttribute('launchStyle', '0')
      ..setAttribute('useCustomWorkingDirectory', 'NO')
      ..setAttribute('ignoresPersistentStateOnLaunch', 'NO')
      ..setAttribute('debugDocumentVersioning', 'YES')
      ..setAttribute('debugServiceExtension', 'internal')
      ..children.add(XmlElement(XmlName('AdditionalOptions'))))
      ..buildConfiguration = buildConfiguration
      ..allowLocationSimulation = allowLocationSimulation;
  }

  /// Whether or not to allow GPS location simulation when launching this target.
  bool get allowLocationSimulation => get('allowLocationSimulation');

  set allowLocationSimulation(bool value) =>
      set('allowLocationSimulation', value);

  /// Whether this Build Action should disable detection of UI API misuse
  /// from background threads
  bool get disableMainThreadChecker => get('disableMainThreadChecker');

  set disableMainThreadChecker(bool value) =>
      set('disableMainThreadChecker', value);

  /// Whether UI API misuse from background threads detection should pause execution.
  ///
  /// This flag is ignored when the thread checker disabled
  /// ([disable_main_thread_checker] flag).
  bool get stopOnEveryMainThreadCheckerIssue =>
      get('stopOnEveryMainThreadCheckerIssue');

  set stopOnEveryMainThreadCheckerIssue(bool value) =>
      set('stopOnEveryMainThreadCheckerIssue', value);

  /// The launch automatically substyle
  String get launchAutomaticallySubstyle => get('launchAutomaticallySubstyle');

  set launchAutomaticallySubstyle(String value) =>
      set('launchAutomaticallySubstyle', value);

  /// The BuildReference to launch when executing the Launch Action
  BuildableProductRunnable get buildableProductRunnable => getSingleChild(
      'BuildableProductRunnable',
      (element) => BuildableProductRunnable._(element));

  set buildableProductRunnable(BuildableProductRunnable value) =>
      setSingleChild(value);

  /// The EnvironmentVariables that will be defined at app launch
  EnvironmentVariables get environmentVariables => getSingleChild(
      'EnvironmentVariables', (element) => EnvironmentVariables._(element));

  set environmentVariables(EnvironmentVariables value) => setSingleChild(value);

  AdditionalOptions get additionalOptions => getSingleChild(
      'AdditionalOptions', (element) => AdditionalOptions._(element));

  set additionalOptions(AdditionalOptions value) => setSingleChild(value);

  /// The CommandLineArguments that will be passed at app launch
  CommandLineArguments get commandLineArguments => getSingleChild(
      'CommandLineArguments', (element) => CommandLineArguments._(element));

  set commandLineArguments(CommandLineArguments value) => setSingleChild(value);
}

class BuildableProductRunnable extends XmlElementWrapper {
  BuildableProductRunnable._(XmlElement element) : super(element);

  factory BuildableProductRunnable({String runnableDebuggingMode}) {
    return BuildableProductRunnable._(
        XmlElement(XmlName('BuildableProductRunnable')))
      ..runnableDebuggingMode = runnableDebuggingMode;
  }

  /// The Runnable debugging mode (usually either empty or equal to '0')
  String get runnableDebuggingMode => get('runnableDebuggingMode');

  set runnableDebuggingMode(String value) =>
      set('runnableDebuggingMode', value);

  /// The Buildable Reference this Buildable Product Runnable is gonna build and run
  BuildableReference get buildableReference => getSingleChild(
      'BuildableReference', (element) => BuildableReference._(element));

  set buildableReference(BuildableReference value) => setSingleChild(value);
}

class EnvironmentVariable extends XmlElementWrapper {
  EnvironmentVariable._(XmlElement element) : super(element);

  factory EnvironmentVariable({String key, String value}) {
    return EnvironmentVariable._(
        XmlElement(XmlName('EnvironmentVariable'))..setAttribute('key', key))
      ..value = value
      ..enabled = true;
  }
  String get key => get('key');

  String get value => get('value');

  set value(String value) => set('value', value);

  bool get enabled => get('enabled');

  set enabled(bool value) => set('enabled', value);
}

class EnvironmentVariables extends XmlElementWrapper
    with MapMixin<String, String> {
  EnvironmentVariables._(XmlElement element) : super(element);

  Set<EnvironmentVariable> get _allVariables => getChildren(
      'EnvironmentVariable', (element) => EnvironmentVariable._(element));
  EnvironmentVariable _getVariable(String key) {
    return _allVariables.firstWhere((element) => element.key == key,
        orElse: () => null);
  }

  @override
  String operator [](Object key) => _getVariable(key)?.value;

  @override
  void operator []=(String key, String value) {
    var v = _getVariable(key);
    if (v == null) {
      _allVariables.add(EnvironmentVariable(key: key, value: value));
    } else {
      v.value = value;
    }
  }

  @override
  void clear() => _allVariables.clear();

  @override
  Iterable<String> get keys => _allVariables.map((e) => e.key);

  @override
  String remove(Object key) {
    var v = _getVariable(key);

    if (v == null) return null;

    _allVariables.removeWhere((e) => e.key == key);
    return v.value;
  }
}

class AdditionalOptions extends XmlElementWrapper {
  AdditionalOptions._(XmlElement element) : super(element);
}

class CommandLineArguments extends XmlElementWrapper with SetMixin<String> {
  CommandLineArguments._(XmlElement element) : super(element);

  Set<CommandLineArgument> get _allArguments => getChildren(
      'CommandLineArgument', (element) => CommandLineArgument._(element));

  CommandLineArgument _getArgument(String argument) =>
      _allArguments.firstWhere((element) => element.argument == argument,
          orElse: () => null);
  @override
  bool add(String value) {
    if (contains(value)) return false;
    _allArguments.add(CommandLineArgument(argument: value));
    return true;
  }

  @override
  bool contains(Object element) =>
      element is String && _getArgument(element) != null;

  @override
  Iterator<String> get iterator =>
      _allArguments.map((v) => v.argument).iterator;

  @override
  int get length => _allArguments.length;

  @override
  String lookup(Object element) => contains(element) ? element : null;

  @override
  bool remove(Object value) {
    var a = _getArgument(value);
    if (a == null) return false;
    a.element.parentElement.children.remove(a.element);
    return true;
  }

  @override
  Set<String> toSet() => {...this};
}

class CommandLineArgument extends XmlElementWrapper {
  CommandLineArgument._(XmlElement element) : super(element);

  factory CommandLineArgument({String argument}) {
    return CommandLineArgument._(XmlElement(XmlName('CommandLineArgument')))
      ..argument = argument;
  }

  /// Returns the CommandLineArgument's key
  String get argument => get('argument');

  set argument(String value) => set('argument', value);

  bool get enabled => get('enabled');

  set enabled(bool value) => set('enabled', value);
}
