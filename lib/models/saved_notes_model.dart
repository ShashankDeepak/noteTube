import 'dart:io';

import 'package:flutter_quill/flutter_quill.dart';

class SavedNote {
  String name = "";
  File file;
  QuillController controller = QuillController.basic();
  SavedNote({
    required this.file,
    required this.name,
    required this.controller,
  }) {}
}
