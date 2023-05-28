import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  TextEditingController youtubeController = TextEditingController();
  QuillController quillController = QuillController.basic();
  ScrollController quillScrollController = ScrollController();
}
