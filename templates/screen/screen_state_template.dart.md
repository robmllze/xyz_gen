````dart
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// GENERATED BY XYZ_GEN
// See: https://github.com/robmllze/xyz_gen
//
// This file is proprietary. No external sharing or distribution.
// Refer to README.md and the project's LICENSE file for details.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

part of '___SCREEN_FILE___';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _State extends MyScreenState<___SCREEN_CLASS___, ___SCREEN_CLASS___Configuration, _Logic> {
  //
  //
  //

  @override
  Widget layout(Widget body) {
    return super.layout(
      SizedBox.expand(
        child: MyScrollable(
          makeup: G.theme.scrollableDefault(),
          child: body,
        ),
      ),
    );
  }

  //
  //
  //

  @override
  Widget body(final context) {
    return MyColumn(
      divider: SizedBox(height: $20),
      children: [
        // Consumer(
        //   builder: (_, final ref, __) {
        //     final value = ref.watch(this.logic.pCounter);
        //     return Text("Count: $value", style: G.theme.textStyles.p1);
        //   },
        // ),
        this.logic.pCounter.build((final value) {
          return Text("Count: $value", style: G.theme.textStyles.p1);
        }),
        MyButton(
          makeup: G.theme.buttonDefault(),
          label: "INCREMENT COUNTER",
          onTap: this.logic.incrementCounter,
        ),
      ],
    );
  }
}
````