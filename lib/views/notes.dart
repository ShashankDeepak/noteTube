import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import '../constants/constants.dart';
import '../controller/controller.dart';
import '../controller/functions.dart';
import '../controller/gpt_controller.dart';

class Notes extends StatelessWidget {
  Notes({super.key});

  final controller = Get.put(Controller());
  final apiController = Get.put(ChatGptController());
  final formGlobalKey = GlobalKey<FormState>();

  Uint8List? imageFile;

  YoutubePlayerController youtubeController = YoutubePlayerController(
      flags: const YoutubePlayerFlags(
        loop: true,
      ),
      initialVideoId: YoutubePlayer.convertUrlToId(getYoutubeLink())!);

  @override
  Widget build(BuildContext context) {
    var fileName = "notes-app";

    AlertDialog alert = AlertDialog(
      title: text("Write File Name"),
      content: SizedBox(
        height: height * 0.25,
        child: Form(
          key: formGlobalKey,
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) {
                  fileName = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Name cant be empty";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "Enter name",
                  label: text("Name"),
                  alignLabelWithHint: true,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: FittedBox(
                  child: text(
                    "Your file will be saved in downloads folder",
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formGlobalKey.currentState!.validate()) {
                        controller.screenshotController
                            .capture()
                            .then((value) => {
                                  imageFile = value,
                                });
                        var status = await Permission.storage.request();
                        if (status.isGranted) {
                          await createPdf(fileName, imageFile!);
                        } else {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: text('Permission Denied'),
                          //   ),
                          // );
                        }

                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: text('Saved'),
                        //   ),
                        // );
                      }
                      FocusScope.of(context).unfocus();
                    },
                    child: text("Save", color: white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.download),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: height,
            width: width,
            child: Column(
              children: [
                YoutubePlayer(
                  aspectRatio: 16 / 9,
                  controller: youtubeController,
                  showVideoProgressIndicator: true,
                  progressColors: const ProgressBarColors(
                    backgroundColor: Colors.red,
                  ),
                  progressIndicatorColor: Colors.red,
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(
                      isExpanded: true,
                      colors: const ProgressBarColors(
                        backgroundColor: Colors.red,
                        bufferedColor: Colors.white,
                        handleColor: Colors.red,
                        playedColor: Colors.grey,
                      ),
                    ),
                    RemainingDuration(),
                    const PlaybackSpeedButton()
                  ],
                ),
                QuillToolbar.basic(
                  multiRowsDisplay: false,
                  showCodeBlock: true,
                  controller: controller.quillController,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Screenshot(
                      controller: controller.screenshotController,
                      child: QuillEditor.basic(
                        controller: controller.quillController,
                        readOnly: false, // true for view only mode
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
