import 'dart:io';

const knownPackageNames = [
  'com.diginik.uk_circle_partners',
  'com.udyamibharat.warrior',
  'com.ub.warrior',
];

String getIosBundleId(String packageName) {
  if (packageName == 'com.diginik.uk_circle_partners') {
    return 'com.diginik.ukCirclePartners';
  }
  return packageName;
}

const filesToUpdate = [
  'android/app/build.gradle.kts',
  'android/app/build.gradle',
  'ios/Runner.xcodeproj/project.pbxproj',
  'linux/CMakeLists.txt',
  'macos/Runner.xcodeproj/project.pbxproj',
  'macos/Runner/Configs/AppInfo.xcconfig',
];

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart run toggle_package_name.dart <target_package_name>');
    print('Options:');
    print('  com.udyamibharat.warrior (UB Play Console)');
    print('  com.ub.warrior (Diginik Play Console)');
    print('  com.diginik.uk_circle_partners (Original)');
    exit(1);
  }

  final targetPackageName = args.first;
  if (!knownPackageNames.contains(targetPackageName)) {
    print(
      'Warning: Target package name "$targetPackageName" is not in the known list. Proceeding anyway...',
    );
  }

  String? currentPackageName;

  // Find current package name from build.gradle.kts
  final buildGradleFile = File('android/app/build.gradle.kts');
  if (buildGradleFile.existsSync()) {
    final content = buildGradleFile.readAsStringSync();
    for (final name in knownPackageNames) {
      if (content.contains(name)) {
        currentPackageName = name;
        break;
      }
    }
  }

  if (currentPackageName == null) {
    print(
      'Could not determine current package name from android/app/build.gradle.kts.',
    );
    exit(1);
  }

  print('Current package name: $currentPackageName');
  print('Target package name: $targetPackageName');

  if (currentPackageName == targetPackageName) {
    print('Already using $targetPackageName. Nothing to do.');
    exit(0);
  }

  final currentIosBundleId = getIosBundleId(currentPackageName);
  final targetIosBundleId = getIosBundleId(targetPackageName);

  // Update text files
  for (final filePath in filesToUpdate) {
    final file = File(filePath);
    if (file.existsSync()) {
      print('Updating $filePath');
      var content = file.readAsStringSync();

      // Update standard package name
      content = content.replaceAll(currentPackageName, targetPackageName);

      // Update iOS specific bundle ID if they differ from the android package name
      if (currentPackageName != currentIosBundleId ||
          targetPackageName != targetIosBundleId) {
        content = content.replaceAll(currentIosBundleId, targetIosBundleId);
      }

      file.writeAsStringSync(content);
    }
  }

  // Handle MainActivity.kt directory movement
  final oldDirPath =
      'android/app/src/main/kotlin/${currentPackageName.replaceAll('.', '/')}';
  final newDirPath =
      'android/app/src/main/kotlin/${targetPackageName.replaceAll('.', '/')}';

  final oldMainActivity = File('$oldDirPath/MainActivity.kt');
  final newMainActivityDir = Directory(newDirPath);

  if (oldMainActivity.existsSync()) {
    print('Moving MainActivity.kt to $newDirPath');
    if (!newMainActivityDir.existsSync()) {
      newMainActivityDir.createSync(recursive: true);
    }

    var ktContent = oldMainActivity.readAsStringSync();
    ktContent = ktContent.replaceAll(
      'package $currentPackageName',
      'package $targetPackageName',
    );

    final newMainActivity = File('$newDirPath/MainActivity.kt');
    newMainActivity.writeAsStringSync(ktContent);

    // Delete old file
    oldMainActivity.deleteSync();

    // Attempt to clean up empty directories
    var currentDir = oldMainActivity.parent;
    final kotlinDir = Directory('android/app/src/main/kotlin').absolute;
    while (currentDir.absolute.path != kotlinDir.path &&
        currentDir.existsSync()) {
      if (currentDir.listSync().isEmpty) {
        currentDir.deleteSync();
        currentDir = currentDir.parent;
      } else {
        break;
      }
    }
  } else {
    print('Warning: MainActivity.kt not found in $oldDirPath');
  }

  print('Package name successfully updated to $targetPackageName');
}
