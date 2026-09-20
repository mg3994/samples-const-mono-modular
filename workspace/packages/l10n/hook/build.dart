import 'dart:io';

void main(List<String> args) async {
  // Execute the standard Flutter localization code generator inside the package directory.
  final result = await Process.run(
    'flutter',
    ['gen-l10n'],
    workingDirectory: Directory.current.path,
    runInShell: true,
  );

  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    exit(result.exitCode);
  }

  stdout.write(result.stdout);
}
