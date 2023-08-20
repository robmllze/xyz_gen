// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Utils
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

class CallDetails {
  //
  //
  //

  final String? fileName;
  final String? className;
  final String? methodName;
  final String? lineNumber;

  //
  //
  //

  const CallDetails._(
    this.fileName,
    this.className,
    this.methodName,
    this.lineNumber,
  );

  //
  //
  //

  factory CallDetails() {
    // Capture the current stack trace.
    final stackTrace = StackTrace.current;
    // Split the stack trace string by line for easier processing.
    final stackTraceLines = stackTrace.toString().split("\n");

    // Start iterating from the 2nd line of the stack trace to skip the current function.
    for (var i = 1; i < stackTraceLines.length; i++) {
      final e = stackTraceLines[i];
      // Use a regular expression to extract details from the stack trace line.
      final match = RegExp(r"#\d+\s+([^\s]+) \(([^\s]+):(\d+):(\d+)\)").firstMatch(e);
      if (match != null) {
        final fileName = match.group(2);

        // Filter out non-project stack trace lines (e.g., those from Dart SDK)
        if (fileName != null && !fileName.startsWith("dart:") && !fileName.startsWith("package:flutter")) {
          final fullMethodName = match.group(1);
          // Split the full method name into class and method parts.
          final parts = fullMethodName?.split('.');
          final className = parts != null && parts.length > 1 ? parts[0] : null;
          final methodName = parts != null && parts.length > 1 ? parts[1] : null;

          // Check if the captured method is not an anonymous closure.
          if (methodName != null && methodName != "<anonymous closure>") {
            // Extract the line number.
            final lineNumber = match.group(3);
            // Return the captured details as an instance of CallDetails.
            return CallDetails._(fileName, className, methodName, lineNumber);
          }
        }
      }
    }
    // If no suitable caller details are found, return an instance of CallDetails with null values.
    return const CallDetails._(null, null, null, null);
  }

  //
  //
  //

  @override
  String toString() {
    return "File: $fileName, Class: $className, Method: $methodName, Line: $lineNumber";
  }
}
