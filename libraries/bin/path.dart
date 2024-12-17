import 'package:path/path.dart' as p;

// The path package provides functions for manipulating file system paths.
void main() {
  var fullPath = p.join('directory', 'file.txt');
  print('Full path: $fullPath');
}