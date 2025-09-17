part of '../scheme.dart';

class ArchiveAction extends SchemeAction {
  ArchiveAction._(super.element);

  factory ArchiveAction(
      {String buildConfiguration = 'Release',
      bool revealArchiveInOrganizer = true,
      String? customArchiveName}) {
    return ArchiveAction._(XmlElement(XmlName('ArchiveAction')))
      ..buildConfiguration = buildConfiguration
      ..revealArchiveInOrganizer = revealArchiveInOrganizer
      ..customArchiveName = customArchiveName;
  }

  /// The custom name to give to the archive.
  String? get customArchiveName => get('customArchiveName');

  set customArchiveName(String? value) => set('customArchiveName', value);

  /// Whether the Archive will be revealed in Xcode's Organizer after it's done building.
  bool? get revealArchiveInOrganizer => get('revealArchiveInOrganizer');

  set revealArchiveInOrganizer(bool? value) =>
      set('revealArchiveInOrganizer', value);
}
