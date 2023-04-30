import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_tube/controller/controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:pdf/widgets.dart' as pw;

import '../constants/constants.dart';

var controller = Get.put(Controller());

String getYoutubeLink() {
  print(controller.youtubeController.text);
  return controller.youtubeController.text;
}

String getYoutubeLinkId() {
  return YoutubePlayer.convertUrlToId(getYoutubeLink())!;
}

Future<String?> getStoragePath() async {
  Directory? directory;
  try {
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');
      // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
      // ignore: avoid_slow_async_io
      if (!await directory.exists()) {}
    }
    return directory.path;
  } catch (err, stack) {
    print("Cannot get download folder path");
  }
}

Future<String> getUniqueFileName(String name, String ext) async {
  int count = 0;
  String fileName = name + '.' + ext;
  while (await File(fileName).exists()) {
    count++;
    fileName = name + ' ($count).' + ext;
  }
  print(fileName);
  return fileName;
}

Future<void> createPdf(String name, Uint8List imageFile) async {
  final pdf = pw.Document();
  final image = pw.MemoryImage(imageFile);

  pdf.addPage(pw.Page(
    build: (pw.Context context) => pw.Positioned(
      left: 0,
      top: 0,
      child: pw.Image(image),
    ),
  ));

  // var directory = await getExternalStorageDirectory();
  var directory = Directory('/storage/emulated/0/Download');
  final path = "${directory.path}/$name.pdf";
  final file = File(path);
  await file.writeAsBytes(await pdf.save());
  if (await canLaunchUrl(Uri.parse(path))) {
    await launchUrl(
      Uri.parse(path),
    );
  } else {
    throw 'Could not launch $path';
  }
}

bool isLinkValid(String link) {
  return regex.hasMatch(link);
}

Future<bool> checkIfFileExists(File file) async {
  return await file.exists();
}
