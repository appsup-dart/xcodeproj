part of xcodeproj.xcscheme;

class TestAction extends SchemeAction {
  TestAction._(XmlElement element) : super(element);

  factory TestAction(
      {bool shouldUseLaunchSchemeArgsEnv = true,
      String buildConfiguration = 'Debug'}) {
    return TestAction._(XmlElement(XmlName('TestAction'))
      ..setAttribute('selectedDebuggerIdentifier',
          'Xcode.DebuggerFoundation.Debugger.LLDB')
      ..setAttribute('selectedLauncherIdentifier',
          'Xcode.DebuggerFoundation.Launcher.LLDB')
      ..children.add(XmlElement(XmlName('AdditionalOptions'))))
      ..shouldUseLaunchSchemeArgsEnv = shouldUseLaunchSchemeArgsEnv
      ..buildConfiguration = buildConfiguration;
  }

  /// Whether this Test Action should use the same arguments and environment variables
  /// as the Launch Action.
  bool get shouldUseLaunchSchemeArgsEnv => get('shouldUseLaunchSchemeArgsEnv');

  set shouldUseLaunchSchemeArgsEnv(bool value) =>
      set('shouldUseLaunchSchemeArgsEnv', value);

  /// Whether this Test Action should disable detection of UI API misuse
  /// from background threads
  bool get disableMainThreadChecker => get('disableMainThreadChecker');

  set disableMainThreadChecker(bool value) =>
      set('disableMainThreadChecker', value);

  /// Whether Clang Code Coverage is enabled ('Gather coverage data' turned ON)
  bool get codeCoverageEnabled => get('codeCoverageEnabled');

  set codeCoverageEnabled(bool value) => set('codeCoverageEnabled', value);

  Set<TestableReference> get testables =>
      getSingleChild('Testables', (e) => XmlElementWrapper(e))
          .getChildren('TestableReference', (e) => TestableReference._(e));

  Set<MacroExpansion> get macroExpansions =>
      getChildren('MacroExpansion', (e) => MacroExpansion._(e));

  /// The EnvironmentVariables that will be defined at app launch
  EnvironmentVariables get environmentVariables => getSingleChild(
      'EnvironmentVariables', (element) => EnvironmentVariables._(element));

  set environmentVariables(EnvironmentVariables value) => setSingleChild(value);

  /// The CommandLineArguments that will be passed at app launch
  CommandLineArguments get commandLineArguments => getSingleChild(
      'CommandLineArguments', (element) => CommandLineArguments._(element));

  set commandLineArguments(CommandLineArguments value) => setSingleChild(value);
}

class TestableReference extends XmlElementWrapper {
  TestableReference._(XmlElement element) : super(element);

  factory TestableReference({bool skipped = false}) {
    return TestableReference._(XmlElement(XmlName('TestableReference')))
      ..skipped = skipped;
  }

  /// Whether or not this TestableReference (test bundle) should be skipped or not
  bool get skipped => get('skipped');

  set skipped(bool value) => set('skipped', value);

  /// Whether or not this TestableReference (test bundle) should be run in parallel or not
  bool get parallelizable => get('parallelizable');

  set parallelizable(bool value) => set('parallelizable', value);

  /// The execution order for this TestableReference (test bundle)
  String get testExecutionOrdering => get('testExecutionOrdering');

  set testExecutionOrdering(String value) =>
      set('testExecutionOrdering', value);

  /// Whether or not this TestableReference (test bundle) should be run in randomized order.
  bool get randomized => testExecutionOrdering == 'random';

  Set<BuildableReference> get buildableReferences =>
      getChildren('BuildableReference', (e) => BuildableReference._(e));

  Set<Test> get skippedTests =>
      getSingleChild('SkippedTests', (e) => XmlElementWrapper(e))
          .getChildren('Test', (e) => Test._(e));

  /// Whether or not this TestableReference (test bundle) should use a whitelist or not
  bool get useTestSelectionWhitelist => get('useTestSelectionWhitelist');

  set useTestSelectionWhitelist(bool value) =>
      set('useTestSelectionWhitelist', value);

  Set<Test> get selectedTests =>
      getSingleChild('SelectedTests', (e) => XmlElementWrapper(e))
          .getChildren('Test', (e) => Test._(e));
}

class MacroExpansion extends XmlElementWrapper {
  MacroExpansion._(XmlElement element) : super(element);

  factory MacroExpansion() {
    return MacroExpansion._(XmlElement(XmlName('MacroExpansion')));
  }

  BuildableReference get buildableReference =>
      getSingleChild('BuildableReference', (e) => BuildableReference._(e));

  set buildableReference(BuildableReference value) => setSingleChild(value);
}

class Test extends XmlElementWrapper {
  Test._(XmlElement element) : super(element);

  factory Test() {
    return Test._(XmlElement(XmlName('Test')));
  }

  String get identifier => get('Identifier');

  set identifier(String value) => set('Identifier', value);
}
