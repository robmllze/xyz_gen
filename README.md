# XYZ Gen

[![pub package](https://img.shields.io/pub/v/xyz_gen.svg)](https://pub.dev/packages/xyz_gen)

`xyz_gen` is a Dart package designed to generate boilerplate code, reducing the amount of repetitive code you need to write.

It comes with a set of generators that can be used as-is, or modified to suit your needs. You can also create your own generators by cloning repository (here)[https://github.com/robmllze/xyz_gen] and modifying the existing generators.

## Included Generators

### generate_exports.dart
Looks through a folder for all Dart files and creates an exports file that includes them all, simplifying your project.

### generate_license_headers.dart
Adds license headers to your files, helping to protect your work.

### generate_makeups.dart
Generates Makeups for widgets, giving them extra styles or features with ease.

### generate_models.dart
Creates model classes from class annotations, handling types better than `json_serializable``.

### generate_preps.dart
Inserts helpful information like line numbers and file names to keep things organized.

### generate_screen.dart (only used in XYZ apps)

Creates Screens for your app, including the boilerplate code needed to get them up and running.

### generate_screen_access.dart (only used in XYZ apps)

Connects your Screens to the navigator.

### generate_configurations.dart (only used in XYZ apps)

Generates code to connect your Screens to your app.

## Getting Started

### Installation

1. Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  xyz_gen: any
```

2. Download the generator scripts here https://github.com/robmllze/xyz_gen/raw/main/___generators.zip and extract them to your project's root directory.
3. Modify the generators as needed. You may also wish to change the generator templates to suit your needs.
4. If you're using VS Code, you can right-click one of the generators, such as `generate_exports.dart`, and select "Run Code".
5. If you're using another IDE, you can run the generators from the command line, e.g. `dart generate_exports.dart`.

## Contributing

Contributions to XYZ Gen are welcome.

## License

This package is released under the MIT License.

## Contact

**Author:** Robert Mollentze

**Email:** robmllze@gmail.com

For more information, questions, or feedback, feel free to contact me.