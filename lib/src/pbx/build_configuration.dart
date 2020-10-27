part of pbx;

mixin XCBuildConfigurationMixin on PBXElement {
  /// The path to a xcconfig file
  PBXFileReference get baseConfigurationReference =>
      project.getObject(get('baseConfigurationReference'));

  set baseConfigurationReference(PBXFileReference value) {
    project.set('objects/$uuid/baseConfigurationReference', value?.uuid);
  }

  /// A map of build settings
  Map<String, dynamic> get buildSettings => getMap('buildSettings');

  set buildSettings(Map<String, dynamic> value) {
    project.set('objects/$uuid/buildSettings', value);
  }

  /// The configuration name
  String get name => get('name');
}

/// element for defining build configuration
class XCBuildConfiguration = PBXElement with XCBuildConfigurationMixin;

mixin XCConfigurationListMixin on PBXElement {
  /// A list of references to [XCBuildConfiguration] elements
  List<XCBuildConfiguration> get buildConfigurations =>
      getObjectList('buildConfigurations');

  ///
  num get defaultConfigurationIsVisible => get('defaultConfigurationIsVisible');

  String get defaultConfigurationName => get('defaultConfigurationName');

  XCBuildConfiguration getByName(String name) =>
      buildConfigurations.firstWhere((v) => v.name == name, orElse: () => null);

  XCBuildConfiguration addBuildConfiguration(String name,
      {Map<String, dynamic> buildSettings,
      PBXFileReference baseConfigurationReference}) {
    var existing = getByName(name);

    if (existing != null) {
      throw StateError('Build configuration with name $name already exists.');
    }

    var uuid = UuidGenerator().random();

    project.set('objects/$uuid', {
      'isa': 'XCBuildConfiguration',
      'name': name,
      'buildSettings': buildSettings ?? {},
      if (baseConfigurationReference != null)
        'baseConfigurationReference': baseConfigurationReference.uuid
    });

    var p = 'objects/${this.uuid}/buildConfigurations';
    project.set(p, [...getList('buildConfigurations'), uuid]);

    return project.getObject(uuid);
  }
}

/// element for defining build configuration
class XCConfigurationList = PBXElement with XCConfigurationListMixin;
