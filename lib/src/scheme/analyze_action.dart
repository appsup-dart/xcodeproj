part of '../scheme.dart';

class AnalyzeAction extends SchemeAction {
  AnalyzeAction._(XmlElement element) : super(element);

  factory AnalyzeAction({String buildConfiguration = 'Debug'}) {
    return AnalyzeAction._(XmlElement(XmlName('AnalyzeAction')))
      ..buildConfiguration = buildConfiguration;
  }
}
