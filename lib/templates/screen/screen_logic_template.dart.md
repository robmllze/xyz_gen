
````dart
//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// GENERATED BY XYZ_GEN
// See: https://github.com/robmllze/xyz_gen
//
// This file is proprietary. No external sharing or distribution.
// Refer to README.md and the project's LICENSE file for details.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

part of '___SCREEN_FILE___';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _Logic extends _LogicBroker<___SCREEN_CLASS___, _State> {
  //
  //
  //

  _Logic(super.screen, super.state);

  //
  //
  //

  final pCounter = Pod<int>(-1);

  //
  //
  //

  void incrementCounter() {
    this.pCounter.update((final value) => value + 1);
  }

  //
  //
  //

  @override
  void initLogic() {
    this.pCounter.set(0);
    super.initLogic();
  }

  //
  //
  //

  @override
  void dispose() {
    // Be sure to dispose all pods here.
    this.pCounter.dispose();
    super.dispose();
  }
}
````