part of xcodeproj.xcscheme;

class ProfileAction extends SchemeAction {
  ProfileAction._(XmlElement element) : super(element);

  factory ProfileAction(
      {String buildConfiguration = 'Release',
      bool shouldUseLaunchSchemeArgsEnv = true}) {
    return ProfileAction._(
        XmlElement(XmlName('ProfileAction'))
          ..setAttribute('savedToolIdentifier', '')
          ..setAttribute('useCustomWorkingDirectory', 'NO')
          ..setAttribute('debugDocumentVersioning', 'YES'))
      ..buildConfiguration = buildConfiguration
      ..shouldUseLaunchSchemeArgsEnv = shouldUseLaunchSchemeArgsEnv;
  }

  /// Whether this Profile Action should use the same arguments and environment variables
  /// as the Launch Action.
  bool? get shouldUseLaunchSchemeArgsEnv => get('shouldUseLaunchSchemeArgsEnv');

  set shouldUseLaunchSchemeArgsEnv(bool? value) =>
      set('shouldUseLaunchSchemeArgsEnv', value);

  /// The BuildableProductRunnable to launch when launching the Profile action
  BuildableProductRunnable get buildableProductRunnable => getSingleChild(
      'BuildableProductRunnable', (e) => BuildableProductRunnable._(e))!;

  set buildableProductRunnable(BuildableProductRunnable e) => setSingleChild(e);
}
