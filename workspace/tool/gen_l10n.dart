import 'dart:io';
import 'package:path/path.dart' as p;

void main(List<String> args) async {
  // Target the packages/l10n directory relative to the workspace root.
  final l10nPath = p.join(Directory.current.path, 'packages', 'l10n');

  final result = await Process.run(
    'flutter',
    ['gen-l10n'],
    workingDirectory: l10nPath,
    runInShell: true,
  );

  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    exit(result.exitCode);
  }

  stdout.write(result.stdout);
}
