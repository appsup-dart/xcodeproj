library xcodeproj.xcscheme;

import 'dart:collection';
import 'dart:io';

import 'package:xcodeproj/src/pbx.dart';
import 'package:xcodeproj/src/xcode.dart';
import 'package:xcodeproj/src/xml_wrapper.dart';
import 'package:xml/src/xml/nodes/element.dart';
import 'package:xml/xml.dart';
import 'package:path/path.dart' as path_lib;

part 'scheme/analyze_action.dart';
part 'scheme/archive_action.dart';
part 'scheme/build_action.dart';
part 'scheme/launch_action.dart';
part 'scheme/profile_action.dart';
part 'scheme/test_action.dart';
part 'scheme/scheme.dart';
