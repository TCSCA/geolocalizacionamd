import 'dart:typed_data';

class FileAmdFormModel {
  String fileName;
  Uint8List file;

  FileAmdFormModel({
    required this.fileName,
    required this.file,
});
}