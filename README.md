# 🇽🇾🇿 Gen

[![pub package](https://img.shields.io/pub/v/xyz_gen.svg)](https://pub.dev/packages/xyz_gen)

This package contains a set of generators to help you with your Flutter projects.

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

### ⚙️ generate_bindings.dart (🛠️ not ready for public use)
Generates code to connect your Screens to your app. Feel free to contact me for more information.

## Getting Started

### Installation

If you are only interested in using the existing generators, there's no need to include this package, but you'll need to include the annotations package by modifying your `pubspec.yaml` file:

```yaml
dependencies:
  xyz_gen_annotations: any  # or the latest version
```

If you want to use the tools included in this package to create your own generators package, you can include it like so:

```yaml
dependencies:
  xyz_gen: any # or the latest version
```

## Next Steps

#### 1. Clone the Generator Scripts:

Navigate to your project directory by running `cd your/project/path` in your terminal. Then clone the generator scripts repository:

##### On macOS and Linux:

```bash
rm -rf ___generators/
git clone https://github.com/robmllze/___generators.git
dart pub get -C ___generators
rm -rf ___generators/.git
```

##### On Windows:

```bash
rmdir /s /q ___generators/
git clone https://github.com/robmllze/___generators.git
dart pub get -C ___generators
rmdir /s /q ___generators/.git
```

This will clone the generator scripts into your project directory and remove the `.git` directory, effectively detaching it from version control so that you can modify it as needed.

#### 2. Modify the Generators as Needed:

Once cloned, you can modify the generator scripts or templates according to your project requirements.

#### 3. Run the Generator Scripts:

Execute any of the generator scripts from the root of your project directory:

```bash
dart ___generators/generate_models.dart
```

Replace `generate_models.dart` with the specific generator you wish to run, for example, `dart generate_exports.dart`.

#### 4. Enhance Workflow Efficiency with VS Code Extensions:

You can also install the [xyz-run-script](https://marketplace.visualstudio.com/items?itemName=robmllze.xyz-run-script) extension to run the generators with a right click or use the [xyz-run-tasks](https://marketplace.visualstudio.com/items?itemName=robmllze.xyz-run-tasks) extension to run the generators via the explorer menu.

## Contributing

Contributions are welcome. Here are a few ways you can help:

- Report bugs and make feature requests.
- Add new features.
- Improve the existing code.
- Help with documentation and tutorials.

## License

This project is released under the MIT License. See [LICENSE](https://raw.githubusercontent.com/robmllze/xyz_gen/main/LICENSE) for more information.

## Contact

**Author:** Robert Mollentze

**Email:** robmllze@gmail.com
