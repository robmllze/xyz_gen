# 🇽🇾🇿 Gen

[![pub package](https://img.shields.io/pub/v/xyz_gen.svg)](https://pub.dev/packages/xyz_gen)

This package is designed to help speed up your development journey by generating boilerplate code for your projects.

It comes with a set of generators that can be used as-is, or modified to suit your needs. Some generators use templates to create files, while others use hard-coded logic to generate or modify existing files. These templates can be modified to suit your needs and can be found in the `templates` folder.

To create your own generators, fork this package from https://github.com/robmllze/xyz_gen and customize it as needed or use this package as a dependency in your own package.

## Documentation

🔜 Documentation and video tutorials are coming soon. Feel free to contact me for more information.

## Included Generators

### ⚙️ generate_directives.dart
A quick way to create missing import, export or part-of directives to your files.

### ⚙️ generate_exports.dart
Looks through a folder for all Dart files and creates an exports file that includes them all, simplifying your project.

### ⚙️ generate_license_headers.dart
Adds license headers to your files, helping to protect your work.

### ⚙️ generate_makeups.dart
Generates Makeups for widgets, giving them extra styles or features with ease.

### ⚙️ generate_models.dart
Creates model classes from class annotations, handling types better than `json_serializable``.

### ⚙️ generate_preps.dart
Inserts helpful information like line numbers and file names to keep things organized.

### ⚙️ generate_type_utils.dart
Generates some utils for annotated Enums.

### ⚙️ generate_screen.dart (🛠️ not ready for public use)
Creates Screens for your app, including the boilerplate code needed to get them up and running. Feel free to contact me for more information.

### ⚙️ generate_screen_access.dart (🛠️ not ready for public use)
Connects your Screens to the navigator. Feel free to contact me for more information.

### ⚙️ generate_configurations.dart (🛠️ not ready for public use)
Generates code to connect your Screens to your app. Feel free to contact me for more information.

## Getting Started

### Installation

#### If you are only interested in using the existing generators, there's no need to include this package, but you'll need to include the annotations package by modifying your `pubspec.yaml` file:

```yaml
dependencies:
  xyz_gen_annotations: any  # or the latest version
```

#### If you want to use the tools included in this package to create your own generators package, you can include it like so:

```yaml
dependencies:
  xyz_gen: any # or the latest version
```

### Next Steps

1. Navigate to your project directory by running `cd your/project/path` then clone the generator scripts via `git clone https://github.com/robmllze/___generators.git`.
1. Modify the generators as needed. You may also wish to change the generator templates to suit your needs.
1. Run any of the generator scripts via `dart ___generators/<GENERATOR>.dart` where `<GENERATOR>` can be any of the included generators, like `dart generate_models.dart`.
1. Consider setting up keyboard shortcuts or single-click actions to quickly run the generators and enhance your workflow efficiency. For instance, in VS Code, you can configure a task to execute the generators. Learn more: https://code.visualstudio.com/docs/editor/tasks.

## Contributing

Contributions are welcome. Here are a few ways you can help:

- Report bugs and make feature requests.
- Add new features.
- Improve the existing code.
- Help with documentation and tutorials.

## License

This package is released under the MIT License.

## Contact

**Author:** Robert Mollentze

**Email:** robmllze@gmail.com