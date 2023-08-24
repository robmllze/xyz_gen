// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Gen
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

import 'package:args/args.dart';
import 'package:xyz_utils/xyz_utils_non_web.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption("directory", abbr: "d", help: "The path to the directory to search for files.");
  final results = parser.parse(arguments);
  final dirPath = results["directory"] ?? "./";
  await deleteGeneratedDartFiles(dirPath);
}

// // my_app.dart

// import 'dart:io';

// void main(List<String> arguments) {
//   print('Hello, Console Application!');

//   // Print the provided arguments
//   if (arguments.isNotEmpty) {
//     print('Received arguments:');
//     for (var arg in arguments) {
//       print(arg);
//     }
//   } else {
//     print('No arguments provided.');
//   }

//   // If you wish to take more input during runtime
//   stdout.write('Enter something: ');
//   String input = stdin.readLineSync();
//   print('You entered: $input');
// }

// void main(List<String> arguments) {
//   final parser = ArgParser()
//     ..addOption('destination', abbr: 'd', help: 'The destination of the action.')
//     ..addFlag('verbose', abbr: 'v', negatable: true, help: 'Displays verbose output.');

//   final results = parser.parse(arguments);

//   if (results.wasParsed('destination')) {
//     print('Destination: ${results['destination']}');
//   }

//   if (results['verbose']) {
//     print('Verbose output enabled!');
//   }
// }
