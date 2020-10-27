A library for reading and modifying XCode projects.



## Usage

A simple usage example:

```dart
import 'package:xcodeproj/xcodeproj.dart';

main() {
  var proj = XCodeProj('path/to/project');
  var target = proj.targets.first;
  var config = target.buildConfigurationList.getByName('Release');
  config.buildSettings['MY_CUSTOM_SETTING'] = 'SOME_VALUE';
  proj.save();
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/appsup-dart/xcodeproj
