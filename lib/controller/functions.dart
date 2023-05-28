import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:note_tube/controller/controller.dart';
import 'package:note_tube/models/saved_notes_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../constants/constants.dart';

var controller = Get.put(Controller());

String getYoutubeLink() {
  print(controller.youtubeController.text);
  return controller.youtubeController.text;
}

String getYoutubeLinkId() {
  return YoutubePlayer.convertUrlToId(getYoutubeLink())!;
}

bool isLinkValid(String link) {
  return regex.hasMatch(link);
}

Future<bool> checkIfFileExists(File file) async {
  return await file.exists();
}

Future<void> writeQuillToStorage(
    {required QuillController quillController, required String name}) async {
  final directory = await getApplicationDocumentsDirectory();
  var file = File("${directory.path}/$name.json");
  // print(file.path);
  var json = jsonEncode(quillController.document.toDelta().toJson());
  if (await checkIfFileExists(file)) {
    throw Exception("File already exists please rename it");
  }
  await file.writeAsString(json);
  // print();
  file.openRead();
}

Future<QuillController> getQuillController(File file) async {
  var controller = QuillController.basic();

  if (await checkIfFileExists(file)) {
    final contents = await file.readAsString();

    List<dynamic> jsonFile = json.decode(contents);

    var doc = Document.fromJson(jsonFile);
    controller = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );

    return controller;
  } else {
    throw Exception("File does not exist");
  }
}

Future<List<SavedNote>> getListOfSavedNotes() async {
  List<SavedNote> notes = [];
  Directory dir = await getApplicationDocumentsDirectory();
  List<FileSystemEntity> files =
      dir.listSync(recursive: true, followLinks: true);

  for (FileSystemEntity file in files) {
    if (file is File && file.path.endsWith(".json")) {
      var controller = await getQuillController(file);

      String fileName = file.path.split('/').last.split(".").first;
      notes.add(
        SavedNote(
          file: file,
          name: fileName,
          controller: controller,
        ),
      );
    }
  }
  return notes;
}
